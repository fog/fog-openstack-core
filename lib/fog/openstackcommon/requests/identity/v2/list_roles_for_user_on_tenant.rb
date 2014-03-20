module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Real

          def list_roles_for_user_on_tenant(tenant_id, user_id)
            request(
              :method   => 'GET',
              :expects  => 200,
              :path     => "/tenants/#{tenant_id}/users/#{user_id}/roles"
            )
          end

        end

        class Mock
        end
      end # OpenStackCommon
    end # V2
  end # Identity
end # Fog
