module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Delete Server Metadata
        #


        def delete_server_metadata_for_key(server_id, key)
          request(
            :method  => 'DELETE',
            :expects => [204],
            :path    => "/servers/#{server_id}/metadata/#{key}",
          )
        end

      end

      class Mock
      end
    end
  end
end
