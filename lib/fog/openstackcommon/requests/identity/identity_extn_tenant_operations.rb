module Fog
  module Identity
    class OpenStackCommon
      class Real

        def create_tenant(attributes)
          request(
            :expects => [200],
            :method  => 'POST',
            :path    => "/tenants",
            :body    =>  MultiJson.encode({ 'tenant' => attributes })
          )
        end # def create_tenant

        # class Mock
        #   def create_tenant(attributes)
        #     response = Excon::Response.new
        #     response.status = [200, 204][rand(1)]
        #     response.body = {
        #       'tenant' => {
        #         'id' => "df9a815161eba9b76cc748fd5c5af73e",
        #         'description' => attributes[:description] || 'normal tenant',
        #         'enabled' => true,
        #         'name' => attributes[:name] || 'default'
        #       }
        #     }
        #     response
        #   end # def create_tenant
        # end

        def update_tenant(id, attributes)
          request(
            :expects => [200],
            :method  => 'PUT',
            :path    => "tenants/#{id}",
            :body    => Fog::JSON.encode({ 'tenant' => attributes })
          )
        end # def update_tenant

        # class Mock
        #   def update_tenant(id, attributes)
        #     response = Excon::Response.new
        #     response.status = [200, 204][rand(1)]
        #     attributes = {'enabled' => true, 'id' => '1'}.merge(attributes)
        #     response.body = {
        #       'tenant' => attributes
        #     }
        #     response
        #   end # def update_tenant
        # end # class Mock

        def delete_tenant(id)
          request(
            :expects => [200, 204],
            :method  => 'DELETE',
            :path    => "tenants/#{id}"
          )
        end # def create_tenant

        # class Mock
        #   def delete_tenant(attributes)
        #     response = Excon::Response.new
        #     response.status = [200, 204][rand(1)]
        #     response.body = {
        #       'tenant' => {
        #         'id' => '1',
        #         'description' => 'Has access to everything',
        #         'enabled' => true,
        #         'name' => 'admin'
        #       }
        #     }
        #     response
        #   end # def create_tenant
        # end # class Mock



        def list_users_for_tenant(tenant_id)
          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => "/tenants/#{tenant_id}/users"
          )
        end

        # class Mock
        #   def list_users(tenant_id = nil)
        #     users = self.data[:users].values
        #
        #     if tenant_id
        #       users = users.select {
        #         |user| user['tenantId'] == tenant_id
        #       }
        #     end
        #
        #
        #     Excon::Response.new(
        #       :body   => { 'users' => users },
        #       :status => 200
        #     )
        #   end
        # end # class Mock





        def add_role_to_user_on_tenant(tenant_id, user_id, role_id)
          request(
            :expects  => 200,
            :method   => 'PUT',
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

        def delete_user_from_tenant(tenant_id, user_id, role_id)
          request(
            :expects => [200, 204],
            :method  => 'DELETE',
            :path    => "/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}"
          )
        end

        # class Mock
        #   def delete_user_role(tenant_id, user_id, role_id)
        #     response = Excon::Response.new
        #     response.status = 204
        #     response
        #   end
        # end



      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
