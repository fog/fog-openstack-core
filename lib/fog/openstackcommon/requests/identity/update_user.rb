module Fog
  module Identity
    class OpenStackCommon
      class Real

        def update_user(user_id, options = {})
          options.merge!('id' => user_id)
          request(
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/users/#{user_id}",
            :body     => MultiJson.encode({ 'user' => options })
          )
        end

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
