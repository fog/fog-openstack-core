module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List floating IP addresses available
        #
        # ==== Parameters
        #
        def list_floating_ips
          request(
            :method  => 'GET',
            :expects => [200],
            :path    => "/os-floating-ips"
          )
        end

      end

      class Mock
      end
    end
  end
end
