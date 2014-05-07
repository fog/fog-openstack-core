require 'fog/openstackcore/service_discovery'

module Fog
  module OpenStackCore

    # This is a proxy class for the Compute Service as a whole, irrespective of
    # what version is required.

    class Compute
      def self.new(options, connection_options = {})
        ServiceDiscovery.new(
          'openstackcore',
          'compute',
          options.merge(:version => 2)
        ).call
      end
    end # Compute

  end # OpenStackCore
end # Fog
