module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def get_tenants_by_name(name, limit = nil, marker = nil)

          params = Hash.new
          params['name']   = name
          params['limit']  = limit  if limit
          params['marker'] = marker if marker

          request(
            :method   => 'GET',
            :expects  => [200],
            :path     => "/v2.0/tenants",
            :query    => params,
            :admin    => true
          )
        end

      end

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
