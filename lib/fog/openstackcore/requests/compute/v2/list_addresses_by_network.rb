module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List addresses
        #

        def list_addresses_by_network(server_id,network_label)
          request(
            :method  => 'GET',
            :expects => [200, 203],
            :path    => "/servers/#{server_id}/ips/#{network_label}"
          )
        end

      end

      class Mock
      end
    end
  end
end
