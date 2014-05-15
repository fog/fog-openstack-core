module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Disassociates a floating IP address from an existing server
        #
        # ==== Parameters
        # * server_id<~Integer> - server id
        # * ip_address<~String> - Ip address to dissassociate
        #

        def disassociate_address(server_id, ip_address)
          body = {"removeFloatingIp" => {"address" => ip_address}}
          server_action(server_id, body)
        end

      end

      class Mock
      end
    end
  end
end
