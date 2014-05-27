module Fog
  module OpenStackCore
    class ComputeV2
      class Real


        # Show Server Metadata for Key
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
        # @param [UUID] server_id id of the relevant server
        # @param [MetadataKey] key key of the metadata item
        #
        # ==== Returns
        # @return [Excon::Response]:
        # * body<~Hash>:
        #   *  :metadata [Hash<Key,Value>]

        def show_server_metadata_for_key(server_id, key)

          request(
            :method  => 'GET',
            :expects => [200, 203],
            :path    => "/servers/#{server_id}/metadata/#{key}",
          )
        end

      end

      class Mock
      end
    end
  end
end
