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
        # @param [UUID] server_id identifier for the server
        # @return <~Excon::Response>:
        #   * body<~Hash>:
        #     * 'addresses'<~Hash>:
        #       * 'public'<~Array> -
        #         * 'version'<~Fixnum>
        #         * 'addr'<~String>
        def list_addresses(server_id)
          request(
            :method  => 'GET',
            :expects => [200, 203],
            :path    => "/servers/#{server_id}/ips"
          )
        end

      end

      class Mock
      end
    end
  end
end
