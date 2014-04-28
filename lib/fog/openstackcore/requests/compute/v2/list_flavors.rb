module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        def list_flavors(tenant_id, options={})

          params = Hash.new
          params['changes-since'] = options['changes-since'] if options['changes-since']
          params['minDisk']  = options[:minDisk] if options[:minDisk]
          params['minRam']  = options[:minRam] if options[:minRam]
          params['limit']  = options[:limit] if options[:limit]
          params['marker'] = options[:marker] if options[:marker]

          request(
            :method   => 'GET',
            :expects  => [200, 203],
            :path     => "/v2/#{tenant_id}/flavors",
            :query    => params
          )
        end

      end

      class Mock
      end
    end
  end
end
