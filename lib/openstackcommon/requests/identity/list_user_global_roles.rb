module Fog
  module Identity
    class OpenStackCommon
      class Real

        def list_user_global_roles(user_id)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "users/#{user_id}/roles"
          )
        end
      end

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
