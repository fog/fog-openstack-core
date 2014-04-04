module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def get_user_by_name(name)
          params = Hash.new
          params['name'] = name

          admin_request(
            :method   => 'GET',
            :expects  => [200, 203],
            :path     => "/v2.0/users",
            :query    => params,
          )
        end

      end

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
