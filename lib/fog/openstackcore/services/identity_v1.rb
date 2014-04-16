module Fog
  module OpenStackCore
    class IdentityV1 < Fog::Service

      requires :openstack_auth_url,
               :openstack_username,
               :openstack_api_key
      recognizes :openstack_auth_token, :openstack_management_url, :persistent,
                  :openstack_service_type, :openstack_service_name, :openstack_tenant,
                  :openstack_api_key, :openstack_username, :openstack_current_user_id,
                  :openstack_endpoint_type,
                  :current_user, :current_tenant

      request_path 'fog/openstackcore/requests/identity/v1'

      ## Token Operations
      request :create_token
      #request :check_token
      #request :validate_token
      #request :list_endpoints_for_token

      # minimal requirement
      class Mock
        def initialize(params); end
      end

      class Real

        #             uri = options[:openstack_auth_uri]
        #             connection = Fog::Connection.new(uri.to_s, false, connection_options)
        #             response = connection.request({
        #               :expects  => [200, 204],
        #               :headers  => {
        #                 'X-Auth-Key'  => options[:openstack_api_key],
        #                 'X-Auth-User' => options[:openstack_username]
        #               },
        #               :method   => 'GET',
        #               :path     =>  (uri.path and not uri.path.empty?) ? uri.path : 'v1.0'
        #             })
        #
        #             return {
        #               :token => response.headers['X-Auth-Token'],
        #               :server_management_url => response.headers['X-Server-Management-Url'] || response.headers['X-Storage-Url'],
        #               :identity_public_endpoint => response.headers['X-Keystone']
        #             }
        #           end
        #
        #         end # AuthenticatorV1


        # attr_reader :service_catalog, :auth_token
        #
        # def initialize(params={})
        #   @options = params.clone
        #
        #   # get an initial connection to Identity on port 5000 to auth
        #   @service = Fog::Core::Connection.new(
        #     @options[:openstack_auth_url].to_s,
        #     @options[:persistent] || false,
        #     @options[:service_options] || {}
        #   )
        #
        #   authenticate
        # end
        #
        # def request(params)
        #   base_request(@service, params)
        # end
        #
        # private
        #
        # def authenticate
        #   return auth_rescope if @options[:openstack_auth_token]
        #   return auth_with_credentials_and_tenant if @options[:openstack_tenant]
        #   return auth_with_credentials
        # end
        #
        # def auth_with_credentials
        #   # puts "\nAUTH WITH CREDS"
        #   validate_credentials(@options[:openstack_username],
        #                       @options[:openstack_api_key])
        #   data = create_token(@options[:openstack_username],
        #                       @options[:openstack_api_key])
        #
        #   # puts "DATA --> #{data.to_yaml}"
        #
        #   @unscoped_token = data.body['access']['token']['id']
        #   @auth_token = @unscoped_token
        #
        #   @service_catalog = nil
        #
        #   @response_hash = {
        #     :user                     => data.body['access']['user'],
        #     :tenant                   => [],
        #     # :identity_public_endpoint => nil,
        #     # :server_management_url    => nil,
        #     :token                    => nil,
        #     :expires                  => data.body['access']['token']['expires'],
        #     :current_user_id          => data.body['access']['user'],
        #     :unscoped_token           => @unscoped_token
        #   }
        #
        #   self
        # end
        #
        # def validate_credentials(username, api_key)
        #   missing_creds = Array.new
        #   missing_creds << :openstack_username unless username
        #   missing_creds << :openstack_api_key  unless api_key
        #   unless missing_creds.empty?
        #     raise ArgumentError,
        #           "Missing required arguments: #{missing_creds.join(', ')}"
        #   end
        # end


      end  # Real

    end  # IdentityV1
  end   # OpenStackCore
end   # Fog
