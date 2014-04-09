require 'fog/openstackcommon/service_discovery'

module Fog
  module OpenStackCommon

    # This is a proxy class for the Compute Service as a whole, irrespective of
    # what version is required.

    class Compute

      def initialize(options, connection_options = {})
        initialize_service(options, connection_options)
      end

      private

      def initialize_service(options, connection_options = {})
        opts = options.dup  # dup options so no wonky side effects
        opts.merge!(:connection_options => connection_options)

        service_discovery = ServiceDiscovery.new("compute", opts)
        service_discovery.call
      end

    end # Compute
  end # OpenStackCommon
end # Fog
