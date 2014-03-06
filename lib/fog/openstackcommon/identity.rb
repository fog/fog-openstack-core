require_relative './core'
require_relative './identity/authenticator'

module Fog
  module Identity
    class OpenStackCommon < Fog::Service

      requires :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url, :persistent,
                  :openstack_service_type, :openstack_service_name, :openstack_tenant,
                  :openstack_api_key, :openstack_username, :openstack_current_user_id,
                  :openstack_endpoint_type,
                  :current_user, :current_tenant

      model_path 'fog/openstackcommon/models/identity'
      model       :tenant
      collection  :tenants
      model       :user
      collection  :users
      model       :role
      collection  :roles
      model       :ec2_credential
      collection  :ec2_credentials

      request_path 'fog/openstackcommon/requests/identity'


      # Administrative API Operations ----------------------------
      # http://docs.openstack.org/api/openstack-identity-service/2.0/content/Admin_API_Service_Developer_Operations-d1e1356.html

      ## Token Operations
      # http://docs.openstack.org/api/openstack-identity-service/2.0/content/Token_Operations.html
      request :check_token
      request :validate_token
      request :list_endpoints_for_token

      ## User Operations
      # http://docs.openstack.org/api/openstack-identity-service/2.0/content/User_Operations.html
      request :admin_api_user_operations

      ## Tenant Operations
      # http://docs.openstack.org/api/openstack-identity-service/2.0/content/Tenant_Operations.html
      request :list_tenants
      request :get_tenants_by_name
      request :get_tenants_by_id
      request :list_roles_for_user_on_tenant


      # Openstack Identity Service Extensions --------------------
      # http://docs.openstack.org/api/openstack-identity-service/2.0/content/openstack_identity_extensions.html

      ## User Operations
      # http://docs.openstack.org/api/openstack-identity-service/2.0/content/User_Operations_OS-KSADM.html
      request :identity_extn_user_operations

      ## Tenant Operations
      # http://docs.openstack.org/api/openstack-identity-service/2.0/content/Tenant_Operations_OS-KSADM.html
      request :identity_extn_tenant_operations

      ## Role Operations
      # http://docs.openstack.org/api/openstack-identity-service/2.0/content/Role_Operations_OS-KSADM.html
      request :identity_extn_role_operations

      ## Service Operations
      #http://docs.openstack.org/api/openstack-identity-service/2.0/content/Service_Operations_OS-KSADM.html
      request :identity_extn_service_operations


      # OS-KSCATALOG Admin Extension ------------------------------
      # http://docs.openstack.org/api/openstack-identity-service/2.0/content/Admin_API_Service_Developer_Operations-OS-KSCATALOG.html

      ## Endpoint Template Operations
      # http://docs.openstack.org/api/openstack-identity-service/2.0/content/Endpoint_Template_Operations_OS-KSCATALOG.html
      # request ???

      ## Endpoint Operations
      # http://docs.openstack.org/api/openstack-identity-service/2.0/content/Tenant_Operations_OS-KSCATALOG.html
      # request ???


      # OS-KSEC2 Admin Extension ----------------------------------
      # http://docs.openstack.org/api/openstack-identity-service/2.0/content/Admin_API_Service_Developer_Operations-OS-KSEC2.html

      ## User Operations
      request :ksec2_extn_user_operations


      # minimal requirement
      class Mock
      end

      class Real
        attr_reader :current_user, :current_tenant, :unscoped_token
        attr_reader :auth_token

        def initialize(options={})
          # puts "===== Fog::Identity::OpenStackCommon -> initialize ====="
          apply_options(options)
          authenticate
          connection_url = "#{@scheme}://#{@host}:#{@port}"
          @connection = Fog::Core::Connection.new(connection_url, @persistent, @connection_options)
        end

        def reload
          # puts "===== Fog::Identity::OpenStackCommon -> reload ====="
          @connection.reset
        end

        def request(params)
          # puts "===== Fog::Identity::OpenStackCommon -> request ====="
          retried = false
          begin
            response = @connection.request(params.merge({
              :headers  => {
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :path     => "#{@base_path}#{params[:path]}"#,
            }))
          rescue Excon::Errors::Unauthorized => error
            raise if retried
            retried = true

            @openstack_must_reauthenticate = true
            authenticate
            retry
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Identity::OpenStackCommon::NotFound.slurp(error)
            else
              error
            end
          end
          unless response.body.empty?
            response.body = MultiJson.decode(response.body)
          end
          response
        end

        private

        def authenticate
          # puts "===== Fog::Identity::OpenStackCommon -> authenticate ====="
          if !@openstack_management_url || @openstack_must_reauthenticate
            case @openstack_auth_uri.path
            when /v1(\.\d+)?/
              Fog::OpenStackCommon::Authenticator.adapter = :authenticator_v1
            else
              Fog::OpenStackCommon::Authenticator.adapter = :authenticator_v2
            end

            options = init_auth_options
            credentials = Fog::OpenStackCommon::Authenticator.adapter.authenticate(options, @connection_options)
            handle_auth_results(credentials)
          else
            @auth_token = @openstack_auth_token
          end

          save_host_attributes
          credentials
        end

        def apply_options(options)

          @openstack_auth_token = options[:openstack_auth_token]
          # puts "openstack_auth_token: #{@openstack_auth_token}"

          unless @openstack_auth_token
            set_credentials(options)
            validate_credentials
          end

          @openstack_tenant   = options[:openstack_tenant]
          # puts "@openstack_tenant: #{@openstack_tenant}"

          @openstack_auth_url = options[:openstack_auth_url]
          @openstack_auth_uri = URI.parse(@openstack_auth_url)
          # puts "@openstack_auth_url: #{@openstack_auth_url}"
          # puts "@openstack_auth_uri: #{@openstack_auth_uri.to_yaml}"

          @openstack_management_url       = options[:openstack_management_url]
          # puts "@openstack_management_url: #{@openstack_management_url}"

          @openstack_must_reauthenticate  = false
          # puts "@openstack_must_reauthenticate: #{@openstack_must_reauthenticate}"

          @openstack_service_type = options[:openstack_service_type] || ['identity']
          # puts "@openstack_service_type: #{@openstack_service_type}"

          @openstack_service_name = options[:openstack_service_name]
          # puts "@openstack_service_name: #{@openstack_service_name}"

          @openstack_current_user_id = options[:openstack_current_user_id]
          # puts "@openstack_current_user_id: #{@openstack_current_user_id}"

          @openstack_endpoint_type = options[:openstack_endpoint_type] || 'adminURL'
          # puts "@openstack_endpoint_type: #{@openstack_endpoint_type}"

          @current_user = options[:current_user]
          # puts "@current_user: #{@current_user}"

          @current_tenant = options[:current_tenant]
          # puts "@current_tenant: #{@current_tenant}"

          @connection_options = options[:connection_options] || {}
          # puts "@connection_options: #{@connection_options}"

          @persistent = options[:persistent] || false
          # puts "@persistent: #{@persistent}"
        end

        def init_auth_options
          { :openstack_api_key  => @openstack_api_key,
            :openstack_username => @openstack_username,
            :openstack_auth_token => @openstack_auth_token,
            :openstack_auth_uri => @openstack_auth_uri,
            :openstack_tenant   => @openstack_tenant,
            :openstack_service_type => @openstack_service_type,
            :openstack_service_name => @openstack_service_name,
            :openstack_endpoint_type => @openstack_endpoint_type
          }
        end

        def handle_auth_results(credentials={})
          @current_user = credentials[:user]
          @current_tenant = credentials[:tenant]
          @openstack_must_reauthenticate = false
          @auth_token = credentials[:token]
          @openstack_management_url = credentials[:server_management_url]
          @openstack_current_user_id = credentials[:current_user_id]
          @unscoped_token = credentials[:unscoped_token]
        end

        def save_host_attributes
          uri = URI.parse(@openstack_management_url)
          @host   = uri.host
          @base_path   = uri.path
          @base_path.sub!(/\/$/, '')
          @port   = uri.port
          @scheme = uri.scheme
          # puts "HOST: #{@host}"
          # puts "path: #{@base_path}"
          # puts "port: #{@port}"
          # puts "scheme: #{@scheme}"
        end

        def set_credentials(options={})
          @openstack_api_key  = options[:openstack_api_key]
          @openstack_username = options[:openstack_username]
        end

        def validate_credentials
          missing_credentials = Array.new
          missing_credentials << :openstack_api_key  unless @openstack_api_key
          missing_credentials << :openstack_username unless @openstack_username
          if !missing_credentials.empty?
            raise ArgumentError, "Missing required arguments: #{missing_credentials.join(', ')}"
          end
        end

      end

    end
  end
end
