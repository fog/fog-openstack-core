module Fog
  module OpenStackCore
    class IdentityV2
      class Real

        def list_tenants(limit = nil, marker = nil)
          params = Hash.new
          params['limit']  = limit  if limit
          params['marker'] = marker if marker

          request(
            :method  => 'GET',
            :expects => [200, 204],
            :path    => "/v2.0/tenants",
            :query   => params
          )
        end

      end

      class Mock
      end
    end # IdentityV2
  end # OpenStackCore
end # Fog
