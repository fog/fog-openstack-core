require 'fog/openstackcore/request_common'

module Fog
  module OpenStackCore
    class ImageV2 < Fog::Service
      requires :openstack_auth_url,
               :openstack_username,
               :openstack_api_key
      recognizes :openstack_auth_token, :openstack_region

      request_path 'fog/openstackcore/requests/image/v2'

      request :get_images_schema

      class Real
        include Fog::OpenStackCore::RequestCommon

        def initialize(options = {})
          identity = Fog::OpenStackCore::ServiceDiscovery.new(
            'openstackcore',
            'identity',
            options.merge(:identity_version => 2)
          ).call
          @identity_session = identity.identity_session
          @auth_token = @identity_session.auth_token

          uri = URI.parse(
            @identity_session.service_catalog.get_endpoint(
              'glance',
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

        def request_params(params)
          super.tap { |new_params|
            new_params[:path] = @path + new_params[:path]
          }
        end
      end

      class Mock
        def initialize(*params) ; end
      end

    end
  end
end
