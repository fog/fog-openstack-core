module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Update Server Metadata
        #
        # ==== Normal Response Codes
        #   * 200
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
        #   * badMediaType (415)
        #   * buildInProgress (409)
        # @param [UUID] server_id
        # @param [Hash] data:
        #   * metadata[Hash '<name>' => '<value>']:
        # @return [Excon::Response]:
        #   * body<~Hash>:
        #     *   'metadata'<~Hash '<name>' => '<value>'>
        #
        def update_server_metadata(server_id, data)
          metadata = {
            :metadata => data
          }
          request(
            :method  => 'POST',
            :expects => [200],
            :path    => "/servers/#{server_id}/metadata",
            :body => MultiJson.encode(metadata),
          )
        end

      end

      class Mock
      end
    end
  end
end
