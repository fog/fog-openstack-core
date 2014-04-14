require 'fog/openstackcommon/service_discovery'

module Fog
  module OpenStackCommon

    class Storage
      
      def self.new(options, connection_options = {})
        service_discovery = ServiceDiscovery.new("storage", opts.merge(
          :connection_options => connection_options,
          :version            => 1
        )
        service_discovery.call
      end
    end
  end
end
