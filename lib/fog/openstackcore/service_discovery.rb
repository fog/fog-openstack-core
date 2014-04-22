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
      attr_accessor :provider

      def self.providers
        @providers ||= {}
      end

      Provider = Struct.new(:name, :base_provider, :services_path)

      def self.register_provider(name, base_provider, path)
        providers[name] = Provider.new(name, base_provider, path)
      end

      def self.unregister_provider(name)
        providers.delete(name)
      end

      # @params service [String] The name of the service to discover upon.
      # This is a downcased String, e.g. "identity" or "storage"
      # @param params [Hash] Optional parameters including:
      # * url of service
      # * the version
      def initialize(provider_name, service, params = {})

        # ToDo: This is a HACKY first cut to get this working...
        # Order of precedence:
        # - Use the version parameter, if available
        # - Use the version embedded in the url, if available
        # - Use the latest stable version available in the service catalog

        @provider           = self.class.providers[provider_name]
        @service_identifier = service.to_s
        @options            = params.dup
      end

      # @return [Fog::Service] Instance of the appropriate type of service
      def call
        klass =
          begin
            Fog::OpenStackCore::Common.string_to_class(service_class_name)
          rescue NameError
            begin
              require "#{provider.services_path}/#{service_identifier}_v#{version}"
            rescue LoadError => e
              raise LoadError, "Failed to find #{service_identifier}_v#{version} for provider #{provider.name} on registered path #{provider.services_path}"
            end

            Fog::OpenStackCore::Common.string_to_class(service_class_name)
          end
        options.delete(:version)
        klass.new(options)
      end

      private

      def version
        if service_identifier == 'identity'
          options[:version] || DEFAULT_VERSION
        else
          options[:version]
        end
      end

      def service_class_name
        return @class_name if @class_name

        service_name = service_identifier.capitalize
        @class_name = "#{provider.base_provider}::#{service_name}V#{version}"
      end

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
    end
  end
end
