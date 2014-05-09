module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List addresses
        #

        def list_networks
          request(
            :method  => 'GET',
            :expects => [200],
            :path    => "/os-networks"
          )
        end

      end

      class Mock
      end
    end
  end
end
