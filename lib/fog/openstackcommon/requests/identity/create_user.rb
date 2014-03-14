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

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
