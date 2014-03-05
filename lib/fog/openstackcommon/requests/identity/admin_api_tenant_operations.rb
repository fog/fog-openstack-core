module Fog
  module Identity
    class OpenStackCommon
      class Real

        def list_tenants(limit = nil, marker = nil)
          params = Hash.new
          params['limit']  = limit  if limit
          params['marker'] = marker if marker

          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => "/tenants",
            :query   => params
          )
        end

        # class Mock
        #   def list_tenants
        #     Excon::Response.new(
        #       :body => {
        #         'tenants_links' => [],
        #         'tenants' => [
        #           {'id' => '1',
        #            'description' => 'Has access to everything',
        #            'enabled' => true,
        #            'name' => 'admin'},
        #           {'id' => '2',
        #            'description' => 'Normal tenant',
        #            'enabled' => true,
        #            'name' => 'default'},
        #           {'id' => '3',
        #            'description' => 'Disabled tenant',
        #            'enabled' => false,
        #            'name' => 'disabled'}
        #         ]
        #       },
        #       :status => [200, 204][rand(1)]
        #     )
        #   end # def list_tenants
        # end

        def get_tenants_by_name(name)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "tenants?name=#{name}"
          )
        end

        def get_tenants_by_id(tenant_id)
          request(
            :expects  => [200, 204],
            :method   => 'GET',
            :path     => "tenants/#{tenant_id}"
          )
        end

        # class Mock
        #   def get_tenant(id)
        #     response = Excon::Response.new
        #     response.status = [200, 204][rand(1)]
        #     response.body = {
        #       'tenant' => {
        #         'id' => id,
        #         'description' => 'Has access to everything',
        #         'enabled' => true,
        #         'name' => 'admin'
        #       }
        #     }
        #     response
        #   end # def list_tenants
        # end # class Mock


        # request :list_roles_for_user_on_tenant
        def list_roles_for_user_on_tenant(tenant_id, user_id)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "tenants/#{tenant_id}/users/#{user_id}/roles"
          )
        end # def list_roles_for_user_on_tenant

        # class Mock
        #   def list_roles_for_user_on_tenant(tenant_id, user_id)
        #     self.data[:user_tenant_membership][tenant_id] ||= {}
        #     self.data[:user_tenant_membership][tenant_id][user_id] ||= []
        #     roles = self.data[:user_tenant_membership][tenant_id][user_id].map do |role_id|
        #       self.data[:roles][role_id]
        #     end
        #
        #     Excon::Response.new(
        #       :body   => { 'roles' => roles },
        #       :status => 200
        #     )
        #   end # def list_roles_for_user_on_tenant
        # end # class Mock


      end

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
