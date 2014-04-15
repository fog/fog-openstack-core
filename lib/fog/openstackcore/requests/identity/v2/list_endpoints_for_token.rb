module Fog
  module OpenStackCore
    class IdentityV2
      class Real

        def list_endpoints_for_token(token_id)
          request(
            :method   => 'GET',
            :expects  => [200, 203],
            :path     => "/v2.0/tokens/#{token_id}/endpoints"
          )
        end

      end

      class Mock
      end
    end # IdentityV2
  end # OpenStackCore
end # Fog
