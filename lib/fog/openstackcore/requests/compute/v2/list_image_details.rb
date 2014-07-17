module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List images
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
        #
        # ==== Parameters
        # * 'image_id'<~UDID> - UUID of the image
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'images'<~Array>:
        #     * 'id'<~UUID> - UUId of the image
        #     * 'name'<~String> - Name of the image
        #     * 'links'<~Array> - array of image links

        def list_image_details(image_id)

          request(
            :method  => 'GET',
            :expects => [200, 203],
            :path    => "/images/#{image_id}"
          )
        end

      end

      class Mock
      end
    end
  end
end
