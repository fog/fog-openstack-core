module Fog
  module Identity
    class OpenStackCommon
      class Real

        def list_endpoints_for_token(token_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "/tokens/#{token_id}/endpoints"
          )
        end

      end

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
