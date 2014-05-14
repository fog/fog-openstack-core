module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Associate a floating IP address with existing server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to associate IP with
        # * ip_address<~String> - IP address to associate with the server
        #
        def add_floating_ip(server_id, ip_address)
          body = {'addFloatingIp' => {'server' => server_id, 'address' => ip_address}}
          server_action(server_id, body)
        end

      end

      class Mock
      end
    end
  end
end
