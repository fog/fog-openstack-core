module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def list_users
          request(
            :method  => 'GET',
            :expects => [200, 204],
            :path    => '/v2.0/users',
            :admin   => true
          )
        end

      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
