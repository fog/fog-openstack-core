module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Real

          def enable_user(user_id, enabled)
            patch = { 'user' => { 'enabled' => enabled } }
            request(
              :method   => 'PUT',
              :expects  => 200,
              :path     => "/users/#{user_id}",
              :body     => MultiJson.encode(patch)
            )
          end

        end

        class Mock
        end
      end # OpenStackCommon
    end # V2
  end # Identity
end # Fog
