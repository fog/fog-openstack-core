module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Show Server Metadata
        #
        # ==== Normal Response Codes
        #   * 200,203
        #
        # ==== Error Response Codes
        #   * computeFault (400, 500, …)
        #   * serviceUnavailable (503)
        #   * badRequest (400)
        #   * unauthorized (401)
        #   * forbidden (403)
        #   * badMethod (405)
        #   * overLimit (413)
        #   * itemNotFound (404)
        #
        # @param [UUID] server_id
        #
        # ==== Returns            s
        #
        # @return [Excon::Response]:
        #   * body<~Hash>:
        #     * 'metadata'<~Hash>
        def show_server_metadata(server_id)
         request(
            :method  => 'GET',
            :expects => [200, 203],
            :path    => "/servers/#{server_id}/metadata",
          )
        end

      end

      class Mock
      end
    end
  end
end
