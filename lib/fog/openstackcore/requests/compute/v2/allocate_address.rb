module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Associate a floating IP address with existing server
        #
        # ==== Parameters
        # * pool<~Integer> - address pool
        #

        def allocate_address(pool = nil)

          request(
            :body    => Fog::JSON.encode({'pool' => pool}),
            :expects => [200, 202],
            :method  => 'POST',
            :path    => 'os-floating-ips.json'
          )
        end

      end

      class Mock
      end
    end
  end
end
