module Fog
  module Identity
    class OpenStackCommon
      class Real

        def add_role_to_user_on_tenant(tenant_id, user_id, role_id)
          request(
            :expects  => 200,
            :method   => 'PUT',
            :path     => "/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}"
          )
        end

      end

      class Mock
        def add_role_to_user_on_tenant(tenant_id, user_id, role_id)
          Excon::Response.new(
            :body   => { 'role' => self.data[:roles][role_id] },
            :status => 200
          )
        end
      end
    end # OpenStackCommon
  end # Identity
end # Fog
