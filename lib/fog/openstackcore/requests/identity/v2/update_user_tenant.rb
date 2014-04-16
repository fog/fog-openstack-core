module Fog
  module OpenStackCore
    class IdentityV2
      class Real

        def update_user_tenant(user_id, options = {})
          options.merge('id' => user_id)
          request(
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/v2.0/users/#{user_id}",
            :body     => MultiJson.encode({ 'user' => options })
          )
        end

      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCore
end # Fog
