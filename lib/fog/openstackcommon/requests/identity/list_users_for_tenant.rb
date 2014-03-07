module Fog
  module Identity
    class OpenStackCommon
      class Real

        def list_users_for_tenant(tenant_id)
          request(
            :expects => [200, 203],
            :method  => 'GET',
            :path    => "/tenants/#{tenant_id}/users"
          )
        end

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
