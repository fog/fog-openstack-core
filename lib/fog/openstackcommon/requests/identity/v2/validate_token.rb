module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def validate_token(token_id, tenant_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "/v2.0/tokens/#{token_id}?belongsTo=#{tenant_id}"
          )
        end

      end

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
