module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Real

          def delete_role_from_user_on_tenant(tenant_id, user_id, role_id)
            request(
              :method  => 'DELETE',
              :expects => [200, 204],
              :path    => "/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}"
            )
          end

        end # Real

        class Mock
        end
      end # OpenStackCommon
    end # V2
  end # Identity
end # Fog
