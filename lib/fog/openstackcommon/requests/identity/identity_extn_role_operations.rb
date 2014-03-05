module Fog
  module Identity
    class OpenStackCommon
      class Real

        def list_roles
          request(
            :expects => 200,
            :method => 'GET',
            :path   => '/OS-KSADM/roles'
          )
        end

        # class Mock
        #   def list_roles
        #     if self.data[:roles].empty?
        #       ['admin', 'Member'].each do |name|
        #         id = Fog::Mock.random_hex(32)
        #         self.data[:roles][id] = {'id' => id, 'name' => name}
        #       end
        #     end
        #     Excon::Response.new(
        #       :body   => { 'roles' => self.data[:roles].values },
        #       :status => 200
        #     )
        #   end
        # end

        def create_role(name)
          data = {
            'role' => {
              'name' => name
            }
          }
          request(
            :body     => MultiJson.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path   => '/OS-KSADM/roles'
          )
        end

        # class Mock
        #   def create_role(name)
        #     data = {
        #       'id'   => Fog::Mock.random_hex(32),
        #       'name' => name
        #     }
        #     self.data[:roles][data['id']] = data
        #     Excon::Response.new(
        #       :body   => { 'role' => data },
        #       :status => 202
        #     )
        #   end
        # end





        def get_role(id)
          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => "/OS-KSADM/roles/#{id}"
          )
        end

        # class Mock
        #   def get_role(id)
        #     response = Excon::Response.new
        #     if data = self.data[:roles][id]
        #       response.status = 200
        #       response.body = { 'role' => data }
        #       response
        #     else
        #       raise Fog::Identity::OpenStackCommon::NotFound
        #     end
        #   end
        # end # class Mock

        def delete_role(role_id)
          request(
            :expects => [200, 204],
            :method => 'DELETE',
            :path   => "/OS-KSADM/roles/#{role_id}"
          )
        end

        # class Mock
        #   def delete_role(role_id)
        #     response = Excon::Response.new
        #     if self.data[:roles][role_id]
        #       self.data[:roles].delete(role_id)
        #       response.status = 204
        #       response
        #     else
        #       raise Fog::Identity::OpenStackCommon::NotFound
        #     end
        #   end
        # end


      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
