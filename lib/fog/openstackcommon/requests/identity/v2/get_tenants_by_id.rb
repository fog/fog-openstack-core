module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def get_tenants_by_id(tenant_id)
          request(
            :method   => 'GET',
            :expects  => [200, 204],
            :path     => "/v2.0/tenants/#{tenant_id}",
            :admin    => true
          )
        end

      end

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
