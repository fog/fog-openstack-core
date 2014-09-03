module Fog
  module OpenStackCore
    class ComputeV2
      class Real
        # Create an image from an existing server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server to create the image from
        # * 'name'<~String> - Name of the image
        # * 'metadata'<~Hash> - A hash of metadata options
        #
        # ==== Returns
        # Does not return a response body.
        def create_image(server_id, name, metadata = {})
          body = {'createImage' =>
                    {'name'     => name,
                     'metadata' => metadata
                    }
          }
          server_action(server_id, body)
        end
      end
      class Mock
      end
    end
  end
end