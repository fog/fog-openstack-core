require 'fog/openstackcore/service_discovery'

module Fog
  module OpenStackCore

    # This is a proxy class for the Block Storage Service as a whole, irrespective of
    # what version is required.

    class BlockStorage
      def self.new(options, connection_options = {})
        ServiceDiscovery.new(
          'openstackcore',
          'block_storage',
          options.merge(:version => 2)
        ).call
      end
    end # BlockStorage

  end # OpenStackCore
end # Fog
