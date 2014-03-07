module Fog
  module Identity
    class OpenStackCommon
      class Real

        def list_users_for_tenant(tenant_id)
          request(
            :method  => 'GET',
            :expects => [200, 203],
            :path    => "/tenants/#{tenant_id}/users"
          )
        end

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
