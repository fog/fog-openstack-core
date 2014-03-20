module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Real

          def validate_token(token_id, tenant_id)
            request(
              :expects  => [200, 203],
              :method   => 'GET',
              :path     => "/tokens/#{token_id}?belongsTo=#{tenant_id}"
            )
          end

        end

        class Mock
        end
      end # OpenStackCommon
    end # V2
  end # Identity
end # Fog
