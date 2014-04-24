require 'fog/openstackcore/service_discovery'

module Fog
  module OpenStackCore
    class Storage
      def self.new(options, connection_options = {})
        ServiceDiscovery.new(
          'openstackcore', 
          'storage', 
          options.merge(:version => 1)
        ).call
      end
    end
  end
end
