module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Real

          def list_endpoints_for_token(token_id)
            request(
              :method   => 'GET',
              :expects  => [200, 203],
              :path     => "/tokens/#{token_id}/endpoints"
            )
          end

        end

        class Mock
        end
      end # OpenStackCommon
    end # V2
  end # Identity
end # Fog
