module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Retrieve VNC console for the specified instance
        #
        # ==== Parameters
        # * 'server_id'<~UUID> - UUId of instance to get console output from
        # ==== Returns
        # # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'console'
        #       * 'type'<~String> - Type of the vnc console
        #       * 'url'<~String> - Url to access a VNC console of a server from a browser
        #
        def get_vnc_console(server_id)
          body = {'os-getVNCConsole' => {'type' => 'novnc'}}
          server_action(server_id, body, 200)
        end

      end

      class Mock
      end
    end
  end
end
