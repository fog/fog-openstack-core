# Factory for Fog::OpenStackCore services.  Services must explicitly register
# with ServiceDiscovery in order to be available for use.
#
# Initially, this class will be used for identity, but no reason it shouldnt
# be used for service/version discovery across all services in the catalog.
module Fog
  module OpenStackCore
    class ServiceDiscovery
      # ToDo - should be able to gather this from classname and remove this
      BASE_PROVIDER = "Fog::OpenStackCore"

      # ToDo - This should be specific to service
      DEFAULT_VERSION = "2"

      attr_accessor :service_identifier  # :identity, :compute, etc.
      attr_accessor :options  # passed in (params)

      # Registers a class as a Fog::Service to be discoverable through
      # ServiceDiscovery
      # @param klass [Class] The Service to register
      def self.register_service(klass)
        assert_namespace_of klass
        @valid_services ||= {}
        @valid_services[registry_name_for(klass)] = klass
      end

      # Unregisters a class from being discoverable.
      # @param klass [Class] The Service to unregister
      def self.unregister_service(klass)
        @valid_services ||= {}
        @valid_services.delete(registry_name_for(klass))
      end

      # @return [Hash] The registered Service classes keyed by their
      # ServiceDiscovery identitier
      def self.valid_services
        @valid_services ||= {}
        @valid_services.dup
      end

      # @params service [String] The name of the service to discover upon.
      # This is a downcased String, e.g. "identity" or "storage"
      # @param params [Hash] Optional parameters including:
      # * url of service
      # * the version
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

      # @return [Fog::Service] Instance of the appropriate type of service
      def call
        service_name = service_identifier.capitalize
        version = options.delete(:version) || DEFAULT_VERSION
        base_provider = options.delete(:base_provider) || BASE_PROVIDER

        klass_name = "#{base_provider}::#{service_name}V#{version}"
        klass =
          begin
            Fog::OpenStackCore::Common.string_to_class(klass_name)
          rescue NameError
            require "fog/openstackcore/services/#{service_name}_v#{version}"
            Fog::OpenStackCore::Common.string_to_class(klass_name)
          end
        klass.new(options)
      end

      private

      def self.assert_namespace_of(klass)
        scope = klass.to_s.split(/::/)
        if scope[0] != "Fog" && scope[1] != "OpenStackCore"
          raise Fog::OpenStackCore::ServiceError, "#{klass} is not in Fog::OpenStackCore"
        end
      end

      def self.class_name_for(klass)
        klass.to_s.split(/::/).last
      end

      def self.registry_name_for(klass)
        class_name_for(klass).downcase
      end

      def validate
        # raise an error unless valid service name/id passed in
        unless self.class.valid_services.include?(service_identifier)
          raise Fog::OpenStackCore::ServiceError
        end
      end

    end
  end
end
