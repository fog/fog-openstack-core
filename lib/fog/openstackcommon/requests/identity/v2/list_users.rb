module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Real

          def list_users
            request(
              :method  => 'GET',
              :expects => [200, 204],
              :path    => '/users'
            )
          end

        end # Real

        class Mock
        end
      end # OpenStackCommon
    end # V2
  end # Identity
end # Fog
