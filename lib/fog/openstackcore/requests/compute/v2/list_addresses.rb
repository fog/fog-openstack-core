module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List addresses
        #


        def list_addresses(server_id)
          request(
            :method  => 'GET',
            :expects => [200, 203],
            :path    => "/servers/#{server_id}/ips",
            :query   => params
          )
        end

      end

      class Mock
      end
    end
  end
end
