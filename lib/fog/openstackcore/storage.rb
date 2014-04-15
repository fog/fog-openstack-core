require 'fog/openstackcore/service_discovery'

module Fog
  module OpenStackCore
    class Storage
      ServiceDiscovery.register_service(self)

      def self.new(options, connection_options = {})
        ServiceDiscovery.new(
          "storage", 
          options.merge(
            :connection_options => connection_options,
            :version            => 1
          )
        ).call
      end
    end
  end
end
