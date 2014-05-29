module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Deallocates the floating IP address
        #
        # @param [UUID] address_id address of address to deallocate
        def deallocate_address(address_id)
            request(
              :expects => [202],
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
