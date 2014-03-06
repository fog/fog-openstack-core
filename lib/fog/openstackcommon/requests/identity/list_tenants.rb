module Fog
  module Identity
    class OpenStackCommon
      class Real

        def list_tenants(limit = nil, marker = nil)
          params = Hash.new
          params['limit']  = limit  if limit
          params['marker'] = marker if marker

          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => "/tenants",
            :query   => params
          )
        end

      end

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
