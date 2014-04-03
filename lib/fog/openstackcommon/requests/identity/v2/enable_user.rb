module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def enable_user(user_id, enabled)
          patch = { 'user' => { 'enabled' => enabled } }
          request(
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/v2.0/users/#{user_id}",
            :body     => MultiJson.encode(patch),
            :admin    => true
          )
        end

      end

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
