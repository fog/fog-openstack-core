require 'fog/openstackcore/request_common'
require "fog/json"

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
      request :create_server
      request :delete_server

      # Flavors
      request :list_flavors

      # Images
      request :list_images
      request :list_image_details

      #Console
      request :server_action
      request :get_console_output
      request :get_vnc_console

      class Mock
        def initialize(params); end
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

          # Retrieve the compute service endpoint
          # ie: http://<host>:8774/v2/<tenant_id>
          uri = URI.parse(
            @identity_session.service_catalog.get_endpoint(
              'nova',
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
