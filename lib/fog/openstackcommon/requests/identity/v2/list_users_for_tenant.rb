module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Real

          def list_users_for_tenant(tenant_id, limit = nil, marker = nil)
            params = Hash.new
            params['limit']  = limit  if limit
            params['marker'] = marker if marker

            request(
              :method  => 'GET',
              :expects => [200, 203],
              :path    => "/tenants/#{tenant_id}/users",
              :query   => params
            )
          end

        end # Real

        class Mock
        end
      end # OpenStackCommon
    end # V2
  end # Identity
end # Fog
