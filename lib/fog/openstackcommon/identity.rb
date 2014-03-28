require 'fog/openstackcommon/service_discovery'

module Fog
  module OpenStackCommon

    # This is a proxy class for the Identity Service as a whole, irrespective of
    # what version is required.

    class Identity

      def initialize(options, connection_options = {})

        puts "IDENTITY (initialize)"

        opts = options.dup  # dup options so no wonky side effects
        opts.merge!(:connection_options => connection_options)

        puts "OPTIONS #{opts}"

        service_discovery =
          Fog::OpenStackCommon::ServiceDiscovery.new("identity", opts)

        puts "SERVICE_DISCOVERY: #{service_discovery.to_yaml}"

        # returns a service instance
        service_discovery.discover
      end

    end # Identity
  end # OpenStackCommon
end # Fog
