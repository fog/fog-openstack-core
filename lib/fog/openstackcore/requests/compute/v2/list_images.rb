module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        def list_images(tenant_id, options={})

          params = Hash.new
          params['changes-since'] = options['changes-since'] if options['changes-since']
          params['server']  = options[:server] if options[:server]
          params['name']  = options[:name] if options[:name]
          params['status']  = options[:status] if options[:status]
          params['limit']  = options[:limit] if options[:limit]
          params['marker'] = options[:marker] if options[:marker]
          params['type'] = options[:type] if options[:type]

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
