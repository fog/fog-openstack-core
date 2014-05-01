require 'fog/openstackcore/request_common'

module Fog
  module OpenStackCore
    class StorageV1 < Fog::Service
      requires :openstack_auth_url,
               :openstack_username,
               :openstack_api_key
      recognizes :openstack_auth_token, :openstack_management_url, :persistent,
                  :openstack_service_type, :openstack_service_name, :openstack_tenant,
                  :openstack_api_key, :openstack_username, :openstack_current_user_id,
                  :openstack_endpoint_type,
                  :current_user, :current_tenant

      request_path 'fog/openstackcore/requests/storage/v1'

      # # Containers
      request :head_containers
      request :get_containers
      # request :delete_container
      # request :get_container

      # # Files
      # request :head_object
      # request :get_objects
      # request :delete_object
      # request :get_object

      # minimal requirement
      class Mock
        def initialize(params); end
      end

      class Real
        include Fog::OpenStackCore::RequestCommon

        attr_reader :token

        def initialize(options = {})
          identity = Fog::OpenStackCore::ServiceDiscovery.new(
            'openstackcore',
            'identity',
            options.merge(:version => 2)
          ).call

          @auth_token = identity.auth_token
          uri = URI.parse(
            identity.service_catalog.get_endpoint(
              'swift',
              options[:openstack_region]
            )
          )
          @path = uri.path

          @connection = Fog::Core::Connection.new(
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
          # TODO: #headers depends on an instance variable set externally. BAD!
          base_request(@connection, params)
        end

        def request_params(params)
          super.tap { |new_params|
            new_params[:path] = @path + new_params[:path]
          }
        end
      end
    end
  end
end
