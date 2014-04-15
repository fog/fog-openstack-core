module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def rescope_token(tenant_name, token)
          data = {
            'auth' => {
              'tenantName' => tenant_name,
              'token' => {
                 'id' => token
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
  end # OpenStackCommon
end # Fog
