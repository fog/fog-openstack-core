require 'multi_json'

module Fog
  module Identity
    class OpenStackCommon
      class Real

        def list_users(tenant_id = nil)
          path = tenant_id ? "/tenants/#{tenant_id}/users" : '/users'
          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => path
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

        def create_user(name, password, email, tenantId=nil, enabled=true)
          data = {
            'user' => {
              'name'      => name,
              'password'  => password,
              'tenantId'  => tenantId,
              'email'     => email,
              'enabled'   => enabled,
            }
          }

          request(
            :body     => MultiJson.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => '/users'
          )
        end

        # class Mock
          # def create_user(name, password, email, tenantId=nil, enabled=true)
          #   response = Excon::Response.new
          #   response.status = 200
          #   data = {
          #     'id'       => Fog::Mock.random_hex(32),
          #     'name'     => name,
          #     'email'    => email,
          #     'tenantId' => tenantId,
          #     'enabled'  => enabled
          #   }
          #   self.data[:users][data['id']] = data
          #   response.body = { 'user' => data }
          #   response
          # end
        # end

        def update_user(user_id, options = {})
          url = options.delete('url') || "/users/#{user_id}"
          request(
            :body     => Fog::JSON.encode({ 'user' => options }),
            :expects  => 200,
            :method   => 'PUT',
            :path     => url
          )
        end

        # class Mock
        #
        #   def update_user(user_id, options)
        #     response = Excon::Response.new
        #     if user = self.data[:users][user_id]
        #       if options['name']
        #         user['name'] = options['name']
        #       end
        #       response.status = 200
        #       response
        #     else
        #       raise Fog::Identity::OpenStackCommon::NotFound
        #     end
        #   end
        #
        # end # Mock

        def delete_user(user_id)
          request(
            :expects => [200, 204],
            :method => 'DELETE',
            :path   => "/users/#{user_id}"
          )
        end

        # class Mock
        #   def delete_user(user_id)
        #     self.data[:users].delete(
        #       list_users.body['users'].find {|x| x['id'] == user_id }['id'])
        #
        #     response = Excon::Response.new
        #     response.status = 204
        #     response
        #   rescue
        #     raise Fog::Identity::OpenStackCommon::NotFound
        #   end
        # end


        def enable_user(user_id)
        end

        def list_global_roles_for_user(user_id)
        end

        def add_global_role_to_user(user_id, role_id)
        end

        def delete_global_role_for_user(user_id, role_id)
        end

        def add_credential_to_user(user_id)
        end

        def update_credential_for_user(user_id, credential_type)
        end

        def delete_credential_for_user(user_id, credential_type)
        end

        def get_user_credentials(user_id, credential_type)
        end

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
