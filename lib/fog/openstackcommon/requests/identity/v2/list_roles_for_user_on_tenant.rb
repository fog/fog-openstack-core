module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def list_roles_for_user_on_tenant(tenant_id, user_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/v2.0/tenants/#{tenant_id}/users/#{user_id}/roles",
            :admin => true
          )
        end

      end

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
