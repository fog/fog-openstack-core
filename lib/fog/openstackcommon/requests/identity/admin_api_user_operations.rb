module Fog
  module Identity
    class OpenStackCommon
      class Real

        def get_user_by_name(name)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "/users?name=#{name}"
          )
        end

        # class Mock
        #   def get_user_by_name(name)
        #     response = Excon::Response.new
        #     response.status = 200
        #     user = self.data[:users].values.select {|user| user['name'] == name}[0]
        #     response.body = {
        #       'user' => user
        #     }
        #     response
        #   end
        # end

        def get_user_by_id(user_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "/users/#{user_id}"
          )
        end

        # class Mock
        #   def get_user_by_id(user_id)
        #     response = Excon::Response.new
        #     response.status = 200
        #
        #     existing_user = self.data[:users].find do |u|
        #         u[0] == user_id || u[1]['name'] == 'mock'
        #       end
        #     existing_user = existing_user[1] if existing_user
        #
        #     response.body = {
        #       'user' => existing_user || create_user('mock', 'mock', 'mock@email.com').body['user']
        #     }
        #     response
        #   end
        # end

        def list_user_global_roles(user_id)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/users/#{user_id}/roles"
          )
        end

      end

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
