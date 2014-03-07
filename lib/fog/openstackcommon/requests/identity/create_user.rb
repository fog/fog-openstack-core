require 'multi_json'

module Fog
  module Identity
    class OpenStackCommon
      class Real

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
            :method   => 'POST',
            :expects  => [200, 202],
            :body     => MultiJson.encode(data),
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

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
