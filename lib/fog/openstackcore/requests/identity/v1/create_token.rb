module Fog
  module OpenStackCore
    class IdentityV1
      class Real

        def create_token(username, password)
          request(
            :method   => 'GET',
            :expects  => [200, 204],
            :headers  => {
              'X-Auth-Key'  => options[:openstack_api_key],
              'X-Auth-User' => options[:openstack_username]
            },
            :path     => '/v1.0/tokens'
          )
        end

        # :path     =>  (uri.path and not uri.path.empty?) ? uri.path : 'v1.0'


      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCore
end # Fog
