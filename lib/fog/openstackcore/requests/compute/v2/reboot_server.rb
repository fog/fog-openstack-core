module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Reboot an existing server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server to reboot
        # * 'type'<~String> - Type of reboot, must be in ['HARD', 'SOFT']
        def reboot_server(server_id, type = 'SOFT')
          body = {'reboot' => {'type' => type}}
          server_action(server_id, body)
        end

      end

      class Mock
      end
    end
  end
end
