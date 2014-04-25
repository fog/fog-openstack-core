require 'fog/openstackcore/service_discovery'

module Fog
  module OpenStackCore

    # This is a proxy class for the Identity Service as a whole, irrespective of
    # what version is required.

    class Identity
      def self.new(options, connection_options = {})
        ServiceDiscovery.new(
          'openstackcore',
          'identity',
          options.merge(:connection_options => connection_options)
        ).call
      end
    end # Identity
  end # OpenStackCore
end # Fog
