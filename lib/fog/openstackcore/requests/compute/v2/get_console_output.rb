module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Retrieve console output for specified instance
        #
        # ==== Parameters
        # * 'server_id'<~Stribng> - UUId of instance to get console output from
        # * 'num_lines'<~Integer> - Number of lines of console output from the end
        # ==== Returns
        # # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'output'<~String> - Console output
        #
        def get_console_output(server_id, output_length=50)
          body = {'os-getConsoleOutput' => {'length' => output_length}}
          server_action(server_id, body, 200)
        end

      end

      class Mock
      end
    end
  end
end
