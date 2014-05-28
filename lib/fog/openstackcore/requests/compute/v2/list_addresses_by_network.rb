module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List addresses
        #
        # ==== Normal Response Codes
        # * 200
        # * 203
        # ==== Error Response Codes
        # * computeFault (400,500...)
        # * serviceUnavailable (503)
        # * badRequest (400)
        # * unauthorized (401)
        # * forbidden (403)
        # * badMethod (405)
        # * overLimit (413)
        # * itemNotFound (404)
        # * buildInProgress (409)
        # @param [UUID] server_id id of the server
        # @param [String] network_label  name of the network
        # @return <~Excon::Response> :
        #   * body<~Hash>:
        #     * 'network'<~Hash>:
        #       * 'id'<~String>:
        #       * 'ip'<~Array>
        #         * 'version'<~Fixnum>
        #         * 'addr'<~String>
        def list_addresses_by_network(server_id,network_label)
          request(
            :method  => 'GET',
            :expects => [200, 203],
            :path    => "/servers/#{server_id}/ips/#{network_label}"
          )
        end

      end

      class Mock
      end
    end
  end
end
