module Fog
  module Identity
    class OpenStackCommon
      class Real

        def add_role_to_user_on_tenant(tenant_id, user_id, role_id)
          request(
            :method   => 'PUT',
            :expects  => [200,201],
            :path     => "/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}"
          )
        end

        # class Mock
        #   def add_role_to_user_on_tenant(tenant_id, user_id, role_id)
        #     Excon::Response.new(
        #       :body   => { 'role' => self.data[:roles][role_id] },
        #       :status => 200
        #     )
        #   end
        # end

        # class Mock
        # def add_user_to_tenant(tenant_id, user_id, role_id)
        #   role = self.data[:roles][role_id]
        #   self.data[:user_tenant_membership][tenant_id] ||= {}
        #   self.data[:user_tenant_membership][tenant_id][user_id] ||= []
        #   self.data[:user_tenant_membership][tenant_id][user_id].push(role['id']).uniq!
        #
        #   response = Excon::Response.new
        #   response.status = 200
        #   response.body = {
        #     'role' => {
        #       'id'   => role['id'],
        #       'name' => role['name']
        #     }
        #   }
        #   response
        # end # def add_user_to_tenant
        # end # class Mock

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
