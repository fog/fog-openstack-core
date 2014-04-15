# service_discovery.rb
# --------------------
# Initially, this class will be used for identity, but no reason it shouldnt
# be used for service/version discovery across all services in the catalog.

# require 'fog/OpenStackCore'

module Fog
  module OpenStackCore
    class ServiceDiscovery

      # ToDo - should be able to gather this from classname and remove this
      BASE_PROVIDER = "Fog::OpenStackCore"
      VALID_SERVICES = ["identity"]
      # ToDo - This should be specific to service
      DEFAULT_VERSION = "2"

      attr_accessor :service_identifier  # :identity, :compute, etc.
      attr_accessor :options  # passed in (params)

      # -- params --
      # service identifier (used to look up service in catalog), required
      # params hash:
      # - url of service, optional
      # - service version, optional, but can be stipulated if desired
      def initialize(service, params = {})

        # ToDo: This is a HACKY first cut to get this working...
        # Order of precedence:
        # - Use the version parameter, if available
        # - Use the version embedded in the url, if available
        # - Use the latest stable version available in the service catalog

        @service_identifier = service.to_s

        validate
        @options = params.dup
      end

      # factory - return the service object ready to be used
      def call
        service_name = service_identifier.capitalize
        version = options[:version] || DEFAULT_VERSION
        base_provider = options.delete(:base_provider) || BASE_PROVIDER

        klass_name = "#{base_provider}::#{service_name}V#{version}"
        klass = Fog::OpenStackCore::Common.string_to_class(klass_name)
        klass.new(options)
      end

      private

      def validate
        # raise an error unless valid service name/id passed in
        unless VALID_SERVICES.include?(service_identifier)
          raise Fog::OpenStackCore::ServiceError
        end
      end

    end
  end
end
