module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def delete_role_from_user_on_tenant(tenant_id, user_id, role_id)
          admin_request(
            :method  => 'DELETE',
            :expects => [200, 204],
            :path    => "/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}",
          )
        end

      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
