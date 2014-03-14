require 'multi_json'

module Fog
  module Identity
    class OpenStackCommon
      class Real

        def delete_user(user_id)
          request(
            :method => 'DELETE',
            :expects => [200, 204],
            :path   => "/users/#{user_id}"
          )
        end

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
