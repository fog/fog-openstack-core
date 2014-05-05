module Fog
  module OpenStackCore
    class ImageV2
      class Real

        def get_images_schema(options = {})
          request(
            :expects  => [200, 204],
            :method   => 'GET',
            :path     => '/v2/schemas/images',
            :query    => {'format' => 'json'}.merge!(options)
          )
        end

      end
    end
  end
end
