require 'fog/openstackcore/request_common'
require 'fog/openstackcore/service_catalog'

module Fog
  module OpenStackCore
    class IdentityV2 < Fog::Service

      requires :openstack_auth_url
      recognizes :openstack_username, :openstack_api_key,
                 :openstack_auth_token, :persistent,
                 :openstack_tenant, :openstack_region

      model_path 'fog/openstackcore/models/identity/v2'
      model       :tenant
      collection  :tenants
      model       :user
      collection  :users
      model       :role
      collection  :roles
      model       :ec2_credential
      collection  :ec2_credentials

      request_path 'fog/openstackcore/requests/identity/v2'

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
        def initialize(params); end
      end

      class Real
        include Fog::OpenStackCore::RequestCommon

        attr_reader :service_catalog, :token, :auth_token, :unscoped_token,
                    :current_tenant, :current_user

        def initialize(params={})
          @options = params.clone

          # get an initial connection to Identity on port 5000 to auth
          @service = Fog::Core::Connection.new(
            @options[:openstack_auth_url].to_s,
            @options[:persistent] || false,
            @options[:connection_options] || {}
          )

          authenticate
        end

        def request(params)
          base_request(@service, params)
        end

        def admin_request(params)
          # create the admin service connection if necessary
          @admin_service ||= admin_connection(:keystone, @options[:openstack_region].to_sym)
          base_request(@admin_service, params)
        end

        private

        # Get an admin connection to Identity
        def admin_connection(service_name, region)

          # get the admin url
          url = @service_catalog.get_endpoint(service_name, region, :admin)

          Fog::Core::Connection.new(
            url,
            @options[:persistent] || false,
            @options[:connection_options] || {}
          )
        end


        def authenticate
          return auth_rescope if @options[:openstack_auth_token]
          return auth_with_credentials_and_tenant if @options[:openstack_tenant]
          return auth_with_credentials
        end

        def auth_rescope
          data = rescope_token(@options[:openstack_tenant],
                               @options[:openstack_auth_token] )

          access_hash = data.body.delete('access')

          @service_catalog =
            ServiceCatalog.from_response(self, access_hash.delete("serviceCatalog"))

          @current_tenant = access_hash['token'].delete('tenant')
          @token = access_hash.delete('token')
          @current_user = access_hash.delete('user')

          @unscoped_token = nil
          @auth_token = @token['id']

          self
        end

        def auth_with_credentials_and_tenant
          validate_credentials(@options[:openstack_username],
                              @options[:openstack_api_key])

          data = create_token(@options[:openstack_username],
                              @options[:openstack_api_key],
                              @options[:openstack_tenant] )

          access_hash = data.body.delete('access')

          @service_catalog =
            ServiceCatalog.from_response(self, access_hash.delete("serviceCatalog"))
          @current_tenant = access_hash['token'].delete('tenant')
          @token = access_hash.delete('token')
          @current_user = access_hash.delete('user')

          @unscoped_token = nil
          @auth_token = @token['id']

          self
        end

        def auth_with_credentials
          validate_credentials(@options[:openstack_username],
                              @options[:openstack_api_key])
          data = create_token(@options[:openstack_username],
                              @options[:openstack_api_key])

          access_hash = data.body.delete('access')

          @service_catalog = nil
          @current_tenant = nil
          @token = access_hash.delete('token')
          @current_user = access_hash.delete('user')

          @unscoped_token = @token['id']
          @auth_token = @unscoped_token

          self
        end

        def validate_credentials(username, api_key)
          missing_creds = Array.new
          missing_creds << :openstack_username unless username
          missing_creds << :openstack_api_key  unless api_key
          unless missing_creds.empty?
            raise ArgumentError,
                  "Missing required arguments: #{missing_creds.join(', ')}"
          end
        end

      end  # Real

    end  # IdentityV2
  end   # OpenStackCore
end   # Fog
