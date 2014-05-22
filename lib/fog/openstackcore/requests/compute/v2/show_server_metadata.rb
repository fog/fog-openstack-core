module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Show Server Metadata
        #
        def show_server_metadata(server_id)
         request(
            :method  => 'GET',
            :expects => [200, 203],
            :path    => "/servers/#{server_id}/metadata",
          )
        end

      end

      class Mock
      end
    end
  end
end
