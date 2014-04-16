module Fog
  module OpenStackCore
    class IdentityV2
      class Real

        # require 'pry'
        # binding.pry
        def create_token(username, password, tenant_name=nil)
          data = {
            'auth' => {
              'tenantName' => tenant_name,
              'passwordCredentials' => {
                'username' => username,
                'password' => password
              }
            }
          }

          request(
            :method   => 'POST',
            :expects  => [200, 202],
            :path     => '/v2.0/tokens',
            :body     => MultiJson.encode(data)
          )
        end

      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCore
end # Fog
