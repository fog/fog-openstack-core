# service_discovery.rb
# --------------------
# Initially, this class will be used for identity, but no reason it shouldnt
# be used for service/version discovery across all services in the catalog.

require 'fog/openstackcommon'

module Fog
  module OpenStackCommon
    class ServiceDiscovery

      # ToDo - should be able to gather this from classname and remove this
      BASE_PROVIDER = "Fog::OpenStackCommon"
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

        puts "ServiceDiscovery (initialize)"
        puts "SID: #{@service_identifier}"
        puts "PARAMS: #{params.to_yaml}"

        validate
        @options = params.dup
      end

      # factory - return the service object ready to be used
      def discover
        service_name = service_identifier.capitalize
        version = options[:version] || DEFAULT_VERSION

        klass_name = "#{BASE_PROVIDER}::#{service_name}V#{version}"
        puts "KLASS NAME: #{klass_name}"
        #klass = Module.const_get(klass_name)
        klass = klass_name.to_class
        klass.new(options)
      end

      private

      def validate
        puts "VALIDATE"
        puts "VS: #{VALID_SERVICES.to_s}"
        puts "SERVICE: #{service_identifier}"

        # raise an error unless valid service name/id passed in
        unless VALID_SERVICES.include?(service_identifier)
          raise Fog::OpenStackCommon::ServiceError
        end
      end

    end
  end
end
