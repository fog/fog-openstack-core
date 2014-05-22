module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Create or Replace Server Metadata
        #


        def create_or_replace_server_metadata(server_id, data)
         metadata = {
           :metadata => data
         }
         request(
            :method  => 'PUT',
            :expects => [200],
            :path    => "/servers/#{server_id}/metadata",
            :body => MultiJson.encode(metadata),
         )
        end

      end

      class Mock
      end
    end
  end
end
