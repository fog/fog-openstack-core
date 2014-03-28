module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        require 'pry'
        binding.pry
        def create_token(username, password, tenant_name=nil)
          data = {
            'auth' => {
              'passwordCredentials' => {
                'username' => username,
                'password' => password
              },
              'tenantName' => tenant_name
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
  end # OpenStackCommon
end # Fog
