require 'fog/openstackcore/request_common'

module Fog
  module OpenStackCore
    class BlockStorageV2 < Fog::Service

      requires :openstack_auth_url,
               :openstack_username,
               :openstack_api_key
      recognizes :openstack_username, :openstack_api_key,
                 :openstack_auth_token, :persistent,
                 :openstack_tenant, :openstack_region

      request_path 'fog/openstackcore/requests/block_storage/v2'

			request :get_volume_details
      request :create_snapshot
      request :delete_snapshot
      request :delete_volume
      request :get_snapshot_details
      request :list_snapshots
      request :list_snapshots_detail
      request :list_volumes
      request :create_volume
      request :delete_volume
      request :list_volumes_detail

      class Mock
        def initialize(params)
          ;
        end
      end

      class Real
        include Fog::OpenStackCore::RequestCommon

        def initialize(options={})

          # Get a reference to the identity service
          identity_options = options.clone
          identity = Fog::OpenStackCore::ServiceDiscovery.new(
            'openstackcore',
            'identity',
            identity_options.merge(:version => 2)
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

          # Contruct the block_storage endpoint
          uri      = URI.parse(
            @identity_session.service_catalog.get_endpoint(
              'cinderv2',
              options[:openstack_region]
            )
          )
          base_url = URI::Generic.build(
            :scheme => uri.scheme,
            :host   => uri.host,
            :port   => uri.port
          ).to_s

          # Extract out everything past the port#
          # ie: /v2/<tenant_id>
          path_prefix = uri.path
          params   = {:path_prefix => path_prefix}

          # Merge connection_options if they exist
          if options[:connection_options]
            params.merge!(options[:connection_options])
          end

          # Establish a compute connection
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