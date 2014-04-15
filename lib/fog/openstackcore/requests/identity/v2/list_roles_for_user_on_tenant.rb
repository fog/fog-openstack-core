module Fog
  module OpenStackCore
    class IdentityV2
      class Real

        def list_roles_for_user_on_tenant(tenant_id, user_id)
          admin_request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles",
          )
        end

      end

      class Mock
      end
    end # IdentityV2
  end # OpenStackCore
end # Fog
