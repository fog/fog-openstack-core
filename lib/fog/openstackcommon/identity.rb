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

      request :check_token
      request :validate_token

      request :list_tenants
      request :create_tenant
      request :get_tenant
      request :get_tenants_by_id
      request :get_tenants_by_name
      request :update_tenant
      request :delete_tenant

      request :list_users
      request :create_user
      request :update_user
      request :delete_user
      request :get_user_by_id
      request :get_user_by_name
      request :add_user_to_tenant
      request :remove_user_from_tenant

      request :list_endpoints_for_token
      request :list_roles_for_user_on_tenant
      request :list_user_global_roles

      request :create_role
      request :delete_role
      request :delete_user_role
      request :create_user_role
      request :get_role
      request :list_roles

      request :set_tenant

      request :create_ec2_credential
      request :delete_ec2_credential
      request :get_ec2_credential
      request :list_ec2_credentials

      # minimal requirement
      class Mock
      end

      class Real
        attr_reader :current_user
        attr_reader :current_tenant
        attr_reader :unscoped_token

        def initialize(options={})
          # puts "===== Fog::Identity::OpenStackCommon -> initialize ====="
          # puts "OPTIONS:"
          # puts options.to_yaml
          # puts " "

          @openstack_auth_token = options[:openstack_auth_token]
          # puts "openstack_auth_token:"
          # puts @openstack_auth_token
          # puts " "

          unless @openstack_auth_token
            # puts "Inside 'unless @openstack_auth_token'"
            missing_credentials = Array.new
            @openstack_api_key  = options[:openstack_api_key]
            @openstack_username = options[:openstack_username]

            missing_credentials << :openstack_api_key  unless @openstack_api_key
            missing_credentials << :openstack_username unless @openstack_username
            raise ArgumentError, "Missing required arguments: #{missing_credentials.join(', ')}" unless missing_credentials.empty?
          end

          @openstack_tenant   = options[:openstack_tenant]
          # puts "@openstack_tenant: #{@openstack_tenant}"

          @openstack_auth_uri = URI.parse(options[:openstack_auth_url])
          # puts "@openstack_auth_uri: #{@openstack_auth_uri}"

          @openstack_management_url       = options[:openstack_management_url]
          # puts "@openstack_management_url: #{@openstack_management_url}"

          @openstack_must_reauthenticate  = false
          # puts "@openstack_must_reauthenticate: #{@openstack_must_reauthenticate}"

          @openstack_service_type = options[:openstack_service_type] || ['identity']
          # puts "@openstack_service_type: #{@openstack_service_type}"

          @openstack_service_name = options[:openstack_service_name]
          # puts "@openstack_service_name: #{@openstack_service_name}"

          @connection_options = options[:connection_options] || {}
          # puts "@connection_options: #{@connection_options}"

          @openstack_current_user_id = options[:openstack_current_user_id]
          # puts "@openstack_current_user_id: #{@openstack_current_user_id}"

          @openstack_endpoint_type = options[:openstack_endpoint_type] || 'adminURL'
          # puts "@openstack_endpoint_type: #{@openstack_endpoint_type}"

          @current_user = options[:current_user]
          # puts "@current_user: #{@current_user}"

          @current_tenant = options[:current_tenant]
          # puts "@current_tenant: #{@current_tenant}"

          authenticate

          @persistent = options[:persistent] || false
          # puts "@persistent: #{@persistent}"

          c = Fog::Core::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
          # puts "@connection: #{c.to_yaml}"

          @connection = c
          @connection
        end

        def credentials
          # puts "===== Fog::Identity::OpenStackCommon -> credentials ====="
          { :provider                   => 'openstack',
            :openstack_auth_url         => @openstack_auth_uri.to_s,
            :openstack_auth_token       => @auth_token,
            :openstack_management_url   => @openstack_management_url,
            :openstack_current_user_id  => @openstack_current_user_id,
            :current_user               => @current_user,
            :current_tenant             => @current_tenant }
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
              :path     => "#{@path}/#{params[:path]}"#,
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
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

        private

        def authenticate
          # puts "===== Fog::Identity::OpenStackCommon -> authenticate ====="
          if !@openstack_management_url || @openstack_must_reauthenticate
            options = {
              :openstack_api_key  => @openstack_api_key,
              :openstack_username => @openstack_username,
              :openstack_auth_token => @openstack_auth_token,
              :openstack_auth_uri => @openstack_auth_uri,
              :openstack_tenant   => @openstack_tenant,
              :openstack_service_type => @openstack_service_type,
              :openstack_service_name => @openstack_service_name,
              :openstack_endpoint_type => @openstack_endpoint_type
            }

            case options[:openstack_auth_uri].path
            when /v1(\.\d+)?/
              Fog::OpenStackCommon::Authenticator.adapter = :authenticator_v1
            else
              Fog::OpenStackCommon::Authenticator.adapter = :authenticator_v2
            end

            credentials = Fog::OpenStackCommon::Authenticator.adapter.authenticate(options, @connection_options)

            @current_user = credentials[:user]
            @current_tenant = credentials[:tenant]

            @openstack_must_reauthenticate = false
            @auth_token = credentials[:token]
            @openstack_management_url = credentials[:server_management_url]
            @openstack_current_user_id = credentials[:current_user_id]
            @unscoped_token = credentials[:unscoped_token]
            uri = URI.parse(@openstack_management_url)
          else
            @auth_token = @openstack_auth_token
            uri = URI.parse(@openstack_management_url)
          end

          @host   = uri.host
          @path   = uri.path
          @path.sub!(/\/$/, '')
          @port   = uri.port
          @scheme = uri.scheme
          true
        end

      end

    end
  end
end