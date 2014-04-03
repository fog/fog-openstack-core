module Fog
  module OpenStackCommon
    class ServiceCatalog

      attr_reader :catalog, :service

      def initialize(attributes)
        @service = attributes.delete(:service)
        @catalog = attributes.delete(:catalog) || {}
      end

      def auth_token
        catalog['access']['token']['id']
      end

      def services
        catalog.collect {|s| s["name"]}
      end

      def get_endpoints(service_name, url_type=:public)
        h = catalog.find {|service| service["name"] == service_name.to_s}
        # puts "H --> #{h.to_yaml}"
        return {} unless h
        key = network_type_key(url_type)
        h["endpoints"].select {|e| e[key]}
      end

      def display_service_regions(service_name, url_type=:public)
        endpoints = get_endpoints(service_name, url_type)
        regions = endpoints.collect do |e|
          e["region"] ? ":#{e["region"].downcase}" : ":global"
        end
        regions.join(", ")
      end

      def get_endpoint(service_name, region=nil, url_type=:public)
        service_region = region_key(region)

        network_type = network_type_key(url_type)

        endpoints = get_endpoints(service_name, url_type)
        raise "Unable to locate endpoint for service #{service_name}" if endpoints.empty?

        if endpoints.size > 1 && region.nil?
          raise "There are multiple endpoints available for #{service_name}. Please specify one of the following regions: #{display_service_regions(service_name)}."
        end

        # select multiple endpoints
        endpoint = endpoints.find {|e| matching_region?(e, service_region) }
        return endpoint[network_type] if endpoint && endpoint[network_type]

        # endpoint doesnt have region
        if endpoints.size == 1 && matching_region?(endpoints[0], "GLOBAL")
          return endpoints[0][network_type]
        end

        raise "Unknown region :#{region} for service #{service_name}. Please use one of the following regions: #{display_service_regions(service_name)}"
      end

      def reload
        @service.authenticate
        @catalog = @service.service_catalog.catalog
        self
      end

      def self.from_response(service, hash)
        ServiceCatalog.new :service => service, :catalog => hash["access"]["serviceCatalog"]
      end

      private

      def network_type_key(url_type)
        # service_net ? "internalURL" : "publicURL"
        return "adminURL" if url_type == :admin
        return "internalURL" if url_type == :internal
        "publicURL"
      end

      def matching_region?(h, region)
        region_key(h["region"]) == region
      end

      def region_key(region)
        return region.to_s.upcase if region.is_a? Symbol
        (region.nil? || region.empty?) ? "GLOBAL" : region.to_s.upcase
      end

    end # ServiceCatalog
  end # OpenStackCommon
end # Fog
