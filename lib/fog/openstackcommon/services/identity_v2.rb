require 'fog/openstackcommon/service_catalog_v2'
require 'fog/openstackcommon/request_common'
# require 'fog/openstackcommon/models/identity/v2/users'

module Fog
  module OpenStackCommon
    class IdentityV2 < Fog::Service

      requires :openstack_auth_url,
               :openstack_username,
               :openstack_api_key
      recognizes :openstack_auth_token, :openstack_management_url,
                 :persistent, :openstack_endpoint_type,
                 :openstack_service_type, :openstack_service_name,
                 :openstack_tenant, :current_tenant,
                 :openstack_current_user_id, :current_user

      model_path 'fog/openstackcommon/models/identity/v2'
      model       :tenant
      collection  :tenants
      model       :user
      collection  :users
      model       :role
      collection  :roles
      model       :ec2_credential
      collection  :ec2_credentials

      request_path 'fog/openstackcommon/requests/identity/v2'

      ## EC2 Credentials
      request :list_ec2_credentials
      request :get_ec2_credential
      request :create_ec2_credential
      request :delete_ec2_credential

      ## Endpoint Operations
      # request :list_endpoints
      # request :get_endpoint
      # request :create_endpoint
      # request :delete_endpoint

      ## Role Operations
      request :list_roles
      request :create_role
      request :get_role
      request :delete_role

      ## Service Operations
      # request :list_services
      # request :create_service
      # request :get_service
      # request :delete_service

      ## Tenant Operations
      request :list_tenants
      request :get_tenants_by_name
      request :get_tenants_by_id
      request :create_tenant
      request :update_tenant
      request :delete_tenant
      request :list_users_for_tenant
      request :list_roles_for_user_on_tenant
      request :add_role_to_user_on_tenant
      request :delete_role_from_user_on_tenant

      ## Token Operations
      request :create_token
      request :rescope_token
      request :check_token
      request :validate_token
      request :list_endpoints_for_token

      ## User Operations
      request :list_users
      request :create_user
      request :update_user
      request :delete_user
      request :enable_user
      # request :list_global_roles_for_user    see -> :list_user_global_roles
      # request :add_global_role_to_user       API returns NotImplemented
      # request :delete_global_role_for_user   API returns NotImplemented
      # request :add_credential_to_user        API returns NotImplemented
      # request :update_credential_for_user    API returns NotImplemented
      # request :delete_credential_for_user    API returns NotImplemented
      # request :get_user_credentials          API returns NotImplemented
      request :get_user_by_name
      request :get_user_by_id
      # request :list_user_global_roles
      #
      # ---- 3/6/2014 ----
      # NOTE - commented request out as not supported in Keystone, even tho the
      # docs might still reference it - irc conversation for background.
      #
      # <wchrisj>	 Am trying to hit this URL, and the docs for v2 say it should work:
      #             http://devstack.local:5000/v2.0/users/{userid}/roles
      # <wchrisj>	 when I manually hit the url, I get a 404 - would I get that if there are no
      #             roles associated with the user in question? stevemar:
      # <@dolphm>	 stevemar: wchrisj: i don't think it's a supported call, as the error message indicates
      # <wchrisj>	 yeah, I'm getting a 404 trying to hit this url
      # <wchrisj>	 http://devstack.local:5000/v2.0/users/2f649419c1ed4801bea38ead0e1ed6ad/roles
      # <@dolphm>	 wchrisj: it's an ambiguously specified API call that we chose to never implement so as
      #             to avoid flip-flopping between the two perceivable interpretations of the spec; instead
      #             we have GET /v3/role_assignments
      # <@dolphm>	 wchrisj: which is much more powerful and avoids any confusing semantics around the call
      # <wchrisj>	 so why do the v2 docs say it exists?
      # <@dolphm>	 wchrisj: because it *may* be implemented by an alternative implementation of the API, but
      #             keystone chooses not to
      # <@dolphm>	 wchrisj: if you have authz on the rackspace public cloud, i think you'll get something
      #             back -- but you'd likely file a bug report because it's not the results you'd expect :)
      # <@dolphm>	 wchrisj: the identity service is one of the few APIs with more than one complete
      #             implementation in production floating around
      # <@dolphm>	 wchrisj: keystone just happens to be the one supported by openstack directly
      # <@dolphm>	 wchrisj: and if you look at the diablo release of keystone vs the essex release of
      #             keystone -- those were actually two completely different implementations from the ground up
      # <ayoung>	 wchrisj, we've stabilized somewhat from that point
      # <@dolphm>	 wchrisj: ++ i'd like it to be removed from openstack's api site since we don't support it directly
      # <@dolphm>	 wchrisj: you're not the only one to be confused by it :(
      # ---- 3/6/2014 ----


      # minimal requirement
      class Mock
      end

      class Real
        include Fog::OpenStackCommon::RequestCommon

        attr_reader :service_catalog, :auth_token

        def initialize(params={})
          puts "\nIDENTITY V2 INITIALIZE"
          puts "PARAMS: #{params.to_yaml}"

          apply_options(params)
          @service = Fog::Core::Connection.new(
            @options[:openstack_auth_url].to_s,
            @options[:persistent] || false,
            @options[:service_options] || {}
          )

          authenticate
        end

        def request(params)
          puts "\nREQUEST"
          my_request(@service, params, @openstack_auth_uri)
        end

        private

        def authenticate
          puts "\nAUTHENTICATE"
          return rescope_token if @auth_token
          return auth_with_credentials_and_tenant if @options[:openstack_tenant]
          return auth_with_credentials
        end

        def rescope_token
          puts "\nRESCOPE"
          data = rescope_token(@options[:openstack_tenant],
                               @auth_token )

          # Set a few ivars we might need
          set_ivars(data.body)
          data
        end

        def auth_with_credentials_and_tenant
          puts "\nAUTH WITH CREDS AND TENANT"
          data = create_token(@options[:openstack_username],
                              @options[:openstack_api_key],
                              @options[:openstack_tenant] )
          # Set a few ivars we might need
          set_ivars(data.body)
          data
        end

        def auth_with_credentials
          puts "\nAUTH WITH CREDS"
          puts "------------------------------"
          # puts "\n\nSELF: #{self.to_yaml}"
          # puts "\n\nSELF METHODS: #{self.methods.sort}"
          # puts "\n\nSELF SINGLETON_METHODS: #{self.singleton_methods.sort}"
          # puts "\n\nSELF PRIVATE_METHODS: #{self.private_methods.sort}"
          # puts "------------------------------"
          # puts "\n\nF::OSC:IV2 methods: #{Fog::OpenStackCommon::IdentityV2.methods.to_yaml}"
          # puts "\n\nF::OSC:IV2 ivars: #{Fog::OpenStackCommon::IdentityV2.instance_variables}"
          # puts "\n\nF::OSC:IV2 cvars: #{Fog::OpenStackCommon::IdentityV2.class_methods}"
          # puts "\n\nF::OSC:IV2 requests: #{Fog::OpenStackCommon::IdentityV2.requests}"
          # puts "------------------------------"
          # puts "\n\nSELF KLASS methods: #{self.class.methods.to_yaml}"
          # puts "------------------------------"
          # puts "\n\nSELF ivars: #{self.instance_variables}"
          # puts "\n\nSELF cvars: #{self.class.class_variables}"
          puts "------------------------------"

          # x = Fog::OpenStackCommon::IdentityV2::Users.new({:service => @service, :tenant_id => "admin"}).all
          # self.users.all

          data = create_token(@options[:openstack_username],
                                   @options[:openstack_api_key])
          # Set a few ivars we might need
          set_ivars(data.body)

          response_hash(data)
        end

        def apply_options(options)
          puts "\nAPPLY OPTIONS"
          @options = options.clone
          puts "\nOPTIONS: #{@options.to_yaml}"
          puts "\nURL: #{@options[:openstack_auth_url].to_s}"
          @openstack_auth_uri = URI.parse(@options[:openstack_auth_url].to_s)
          puts "\nURI: #{@openstack_auth_uri}"
        end

        def set_ivars(body)
          puts "\nDATA: #{body.to_yaml}"

          @token = body['access']['token']
          puts "\nTOKEN: #{@token.to_yaml}"

          if @token.has_key?('tenant')
            @tenant = @token['tenant']
            puts "\nTENANT: #{@tenant.to_yaml}"
          end

          @auth_token = @token['id']
          puts "\nAUTH TOKEN: #{@auth_token}"

          @service_catalog =
            Fog::OpenStackCommon::ServiceCatalog.from_response(self, body)
          puts "\nSERVICE CATALOG: #{@service_catalog.to_yaml}"
        end

        def response_hash(data)
          {
            :user                     => nil,
            :tenant                   => nil,
            :identity_public_endpoint => nil,
            :server_management_url    => nil,
            :token                    => nil,
            :expires                  => nil,
            :current_user_id          => nil,
            :unscoped_token           => nil
          }
        end

      end  # Real

    end  # IdentityV2
  end   # OpenStackCommon
end   # Fog
