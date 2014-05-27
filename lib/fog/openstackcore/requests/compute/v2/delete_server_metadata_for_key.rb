module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Delete Server Metadata
        #
        # ==== Normal Response Codes
        #   * 204
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
        # @param [String] key
        # @return nil
        def delete_server_metadata_for_key(server_id, key)
          request(
            :method  => 'DELETE',
            :expects => [204],
            :path    => "/servers/#{server_id}/metadata/#{key}",
          )
        end

      end

      class Mock
      end
    end
  end
end
