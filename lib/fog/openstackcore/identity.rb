require 'fog/openstackcore/service_discovery'

module Fog
  module OpenStackCore

    # This is a proxy class for the Identity Service as a whole, irrespective of
    # what version is required.

    class Identity
      ServiceDiscovery.register_service(self)

      def self.new(options = {})
        service_discovery = ServiceDiscovery.new("identity", options)
        service_discovery.call
      end

    end # Identity
  end # OpenStackCore
end # Fog
