module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def list_users_for_tenant(tenant_id, limit = nil, marker = nil)
          params = Hash.new
          params['limit']  = limit  if limit
          params['marker'] = marker if marker

          admin_request(
            :method  => 'GET',
            :expects => [200, 203],
            :path    => "/v2.0/tenants/#{tenant_id}/users",
            :query   => params,
          )
        end

      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
