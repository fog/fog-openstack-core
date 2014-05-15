module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Associate a floating IP address with existing server
        #
        # ==== Parameters
        # * pool<~Integer> - address pool
        #

        def deallocate_address(address_id)
            request(
              :expects => [200, 202],
              :method => 'DELETE',
              :path   => "os-floating-ips/#{address_id}"
            )
        end

      end

      class Mock
      end
    end
  end
end
