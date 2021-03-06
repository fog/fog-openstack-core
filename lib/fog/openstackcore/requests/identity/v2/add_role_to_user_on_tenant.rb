module Fog
  module OpenStackCore
    class IdentityV2
      class Real

        def add_role_to_user_on_tenant(tenant_id, user_id, role_id)
          admin_request(
            :method   => 'PUT',
            :expects  => [200,201],
            :path     => "/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}", 
          )
        end

      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCore
end # Fog
