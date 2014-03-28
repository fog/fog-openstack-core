module Fog
  module OpenStackCommon
    class IdentityV2
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
            :path     => '/v2.0/users'
          )
        end

      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
