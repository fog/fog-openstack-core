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
        #   * 'status'<~ServerStatus> - Value of the status of the server so that you can filter on "ACTIVE" for example
        #   * 'host'<~String> - Name of the host as a string.
        #
        # ==== Returns

        def list_servers(tenant_id, options = {})

          params = Hash.new
          params['changes-since'] = options['changes-since'] if options['changes-since']
          params['image']  = options[:image] if options[:image]
          params['flavor']  = options[:flavor] if options[:flavor]
          params['name']  = options[:name] if options[:name]
          params['limit']  = options[:limit] if options[:limit]
          params['marker'] = options[:marker] if options[:marker]
          params['status']  = options[:status] if options[:status]
          params['host']  = options[:host] if options[:host]
          params['format'] = 'json'

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
