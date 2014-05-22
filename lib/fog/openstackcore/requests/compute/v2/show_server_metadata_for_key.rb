module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Show Server Metadata
        #


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
