module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Real

          def list_tenants(limit = nil, marker = nil)
            params = Hash.new
            params['limit']  = limit  if limit
            params['marker'] = marker if marker

            request(
              :method  => 'GET',
              :expects => [200, 204],
              :path    => "/tenants",
              :query   => params
            )
          end

        end

        class Mock
        end
      end # OpenStackCommon
    end # V2
  end # Identity
end # Fog
