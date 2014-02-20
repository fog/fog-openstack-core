module Fog
  module OpenStack
    module Authentication
      module Adapters
        module AuthenticatorV1
          extend self

          def authenticate(options, connection_options = {})

            uri = options[:openstack_auth_uri]
            connection = Fog::Connection.new(uri.to_s, false, connection_options)
            response = connection.request({
              :expects  => [200, 204],
              :headers  => {
                'X-Auth-Key'  => options[:openstack_api_key],
                'X-Auth-User' => options[:openstack_username]
              },
              :method   => 'GET',
              :path     =>  (uri.path and not uri.path.empty?) ? uri.path : 'v1.0'
            })

            return {
              :token => response.headers['X-Auth-Token'],
              :server_management_url => response.headers['X-Server-Management-Url'] || response.headers['X-Storage-Url'],
              :identity_public_endpoint => response.headers['X-Keystone']
            }
          end

        end # AuthenticatorV1
      end # Adapters
    end # Authentication
  end # OpenStack
end # Fog