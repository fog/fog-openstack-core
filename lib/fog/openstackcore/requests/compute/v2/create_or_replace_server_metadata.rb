module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Create or Replace Server Metadata
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
        # @param [UUID] server_id the server identifier
        # @param [Hash] data the hash of data
        #     * metadata [Hash]
        # @return [Excon::Response]:
        #   * body [Hash]:
        #     *   metadata [Hash]
        def create_or_replace_server_metadata(server_id, data)
         metadata = {
           :metadata => data
         }
         request(
            :method  => 'PUT',
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
