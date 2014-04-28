require 'fog/openstackcore/request_common'

module Fog
  module OpenStackCore
    class ComputeV2 < Fog::Service
      requires :openstack_auth_url,
               :openstack_username,
               :openstack_api_key
      recognizes :openstack_username, :openstack_api_key,
                 :openstack_auth_token, :persistent,
                 :openstack_tenant, :openstack_region

      request_path 'fog/openstackcore/requests/compute/v2'

      # Server CRUD
      request :list_servers
      # request :list_servers_detail
      # request :create_server
      # request :get_server_details
      # request :update_server
      # request :delete_server

      # Flavors
      request :list_flavors

      # Images
      request :list_images

      
      class Mock
        def initialize(params); end
      end

      class Real
        include Fog::OpenStackCore::RequestCommon

        # attr_reader :service_catalog, :token, :auth_token, :unscoped_token,
        #             :current_tenant, :current_user

        def initialize(options={})
          identity = Fog::OpenStackCore::ServiceDiscovery.new(
            'openstackcore',
            'identity',
            options.merge(:version => 2)
          ).call
          @auth_token = identity.auth_token

          unless identity.service_catalog
            raise <<-SC_ERROR
            Unable to retrieve service catalog. Be sure to include a minimum
            of the following in the params hash:
            - provider
            - openstack_auth_url
            - openstack_username
            - openstack_api_key
            - openstack_tenant
            - openstack_region
            SC_ERROR
          end

          uri = URI.parse(
            identity.service_catalog.get_endpoint(
              'nova',
              options[:openstack_region]
            )
          )
          @path = uri.path

          @service = Fog::Core::Connection.new(
            URI::Generic.build(
              :scheme => uri.scheme,
              :host   => uri.host,
              :port   => uri.port
            ).to_s,
            options[:persistent] || false,
            options[:connection_options] || {}
          )
        end

        def request(params)
          base_request(@service, params)
        end

        # def admin_request(params)
        #   # create the admin service connection if necessary
        #   @admin_service ||= admin_connection(:keystone, @options[:openstack_region].to_sym)
        #   base_request(@admin_service, params)
        # end

        def reload
          @service.reset
        end

      end
    end
  end
end
