module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Delete an existing server
        #
        # Normal Response Codes
        # * 204
        #
        # ==== Error Response Codes
        # * serviceUnavailable (503)
        # * badRequest (400)
        # * unauthorized (401)
        # * forbidden (403)
        # * badMethod (405)
        # * overLimit (413)
        # * itemNotFound (404)
        # * buildInProgress (409)
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of the server to delete
        #
        def delete_server(server_id)
          request(
            :method => 'DELETE',
            :expects => 204,
            :path   => "/servers/#{server_id}"
          )
        end

      end

      class Mock
      end
    end
  end
end
