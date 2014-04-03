module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def delete_user(user_id)
          request(
            :method  => 'DELETE',
            :expects => [200, 204],
            :path    => "/v2.0/users/#{user_id}",
            :admin   => true
          )
        end

      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
