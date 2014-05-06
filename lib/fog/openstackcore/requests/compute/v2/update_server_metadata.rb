module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Create or Replace Server Metadata
        #


        def update_server_metadata(tenant_id, server_id, data)
          metadata = {
            :metadata => data
          }
          request(
            :method  => 'POST',
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
