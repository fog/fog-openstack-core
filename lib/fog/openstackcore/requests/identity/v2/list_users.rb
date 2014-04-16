module Fog
  module OpenStackCore
    class IdentityV2
      class Real

        def list_users
          admin_request(
            :method  => 'GET',
            :expects => [200, 204],
            :path    => '/v2.0/users',
          )
        end

      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCore
end # Fog
