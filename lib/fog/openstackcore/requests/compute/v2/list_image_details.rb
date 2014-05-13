module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List images
        #
        # ==== Parameters
        # * 'image_id'<~String> - UUID of the image
              #
        # ==== Returns

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
