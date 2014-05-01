module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List images
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'changes-since'<~DateTime> - A time/date stamp for when the image last changed status.
        #   * 'server'<~URI> - Name of the server in URL format
        #   * 'name'<~String> - Name of the image as a string
        #   * 'status'<~ImageStatus> - Value of the status of the image so that you can filter on "ACTIVE" for example
        #   * 'marker'<~UUID> - UUID of the image at which you want to set a marker
        #     Only return objects with name greater than this value
        #   * 'limit'<~Integer> - Upper limit to number of results returned
        #     Integer value for the limit of values to return.
        #   * 'type'<~String> - Value of the type of image, such as BASE, SERVER, or ALL.
        #
        # ==== Returns
        # * images<~ImagesWithOnlyIDsNamesLinks>:
        #   Image information.
        # * 'next'<~UUID> - Moves to the next metadata item.
        # * 'previous'<~UUID> - Moves to the previous metadata item.

        def list_images(tenant_id, options={})
          params = Fog::OpenStackCore::Common.whitelist_keys(options, 
            %w{changes-since server name status marker limit type})

          request(
            :method   => 'GET',
            :expects  => [200, 203],
            :path     => "/v2/#{tenant_id}/images",
            :query    => params
          )
        end

      end

      class Mock
      end
    end
  end
end
