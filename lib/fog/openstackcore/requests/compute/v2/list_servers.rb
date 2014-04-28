module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List existing servers
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'changes-since'<~DateTime> - A time/date stamp for when the server last changed status.
        #   * 'image'<~URI> - Name of the image in URL format
        #   * 'flavor'<~URI> - Name of the flavor in URL format
        #   * 'name'<~String> - Name of the server as a string
        #   * 'limit'<~Integer> - Upper limit to number of results returned
        #     Integer value for the limit of values to return.
        #   * 'marker'<~UUID> - UUID of the server at which you want to set a marker
        #     Only return objects with name greater than this value
        #   * 'status'<~ServerStatus> - Value of the status of the server so that you can filter 
        #     on "ACTIVE" for example
        #   * 'host'<~String> - Name of the host as a string.
        #
        # ==== Returns
        # * servers<~ServersWithOnlyIDsNamesLinks>:
        #   List of servers.
        # * 'next'<~UUID> - Moves to the next metadata item.
        # * 'previous'<~UUID> - Moves to the previous metadata item.

        def list_servers(tenant_id, options = {})
          opts = Fog::OpenStackCore::Common.stringify_keys(options)
          params = Fog::OpenStackCore::Common.whitelist_keys(
            opts, %w{changes-since image flavor name limit marker status host})

          request(
            :method   => 'GET',
            :expects  => [200, 203],
            :path     => "/v2/#{tenant_id}/servers",
            :query    => params
          )
        end

      end

      class Mock
      end
    end
  end
end
