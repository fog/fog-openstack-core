module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Associate a floating IP address with existing server
        #
        # ==== Normal Response Codes
        #   * 202
        # ==== Parameters
        # * server_id<~UUID> - Id of server to associate IP with
        # * ip_address<~String> - IP address to associate with the server
        #
        def associate_address(server_id, ip_address)
          body = {'addFloatingIp' => { 'address' => ip_address }}
          server_action(server_id, body)
        end



      end

      class Mock
      end
    end
  end
end
