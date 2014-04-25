module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        def list_flavors
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => '/v2/flavors',
            :query    => {'format' => 'json'}
          )
        end

      end

      class Mock
      end
    end
  end
end
