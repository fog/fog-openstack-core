module Fog
  module Identity
    class OpenStackCommon
      class Real

        def delete_role_from_user_on_tenant(tenant_id, user_id, role_id)
          request(
            :expects => [200, 204],
            :method  => 'DELETE',
            :path    => "/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}"
          )
        end

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
