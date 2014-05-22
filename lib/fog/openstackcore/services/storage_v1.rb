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
          # Get a reference to the identity service
          identity = Fog::OpenStackCore::ServiceDiscovery.new(
            'openstackcore',
            'identity',
            options.merge(:version => 2)
          ).call

          @identity_session = identity.identity_session
          unless @identity_session.service_catalog
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

          # Retrieve the storage service endpoint
          # ie: http://<host>:8774/v2/<tenant_id>
          uri = URI.parse(
            @identity_session.service_catalog.get_endpoint(
              'swift',
              options[:openstack_region]
            )
          )

          # Extract out the base service url
          # ie: http://<host>:8774
          base_url = URI::Generic.build(
            :scheme => uri.scheme,
            :host   => uri.host,
            :port   => uri.port
          ).to_s

          # Extract out everything past the port#
          # ie: /v2/<tenant_id>
          path_prefix = uri.path
          params = {:path_prefix => path_prefix}

          # Merge connection_options if they exist
          if options[:connection_options]
            params.merge(options[:connection_options])
          end

          # Establish a storage connection
          @connection = Fog::Core::Connection.new(
            base_url,
            options[:persistent] || false,
            params || {}
          )
        end

        def request(params)
          base_request(@connection, params)
        end

        def reload
          @connection.reset
        end

      end
    end
  end
end
