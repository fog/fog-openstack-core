require 'fog/openstackcore/service_discovery'

module Fog
  module OpenStackCore
    class Image
      def self.new(options, connection_options = {})
        ServiceDiscovery.new(
          'openstackcore',
          'image',
          options.merge(:version => 2)
        ).call
      end
    end
  end
end
