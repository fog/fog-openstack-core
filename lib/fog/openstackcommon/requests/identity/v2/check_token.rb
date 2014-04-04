module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def check_token(token_id, tenant_id)
          request(
            :method   => 'HEAD',
            :expects  => [200, 203, 204],
            :path     => "/v2.0/tokens/#{token_id}?belongsTo=#{tenant_id}", 
            :admin    => true
          )
        end

      end

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
