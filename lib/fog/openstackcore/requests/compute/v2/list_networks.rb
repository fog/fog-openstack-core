module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List addresses
        #
        # @return <~Excon::Response> response:
        #   * body<~Hash>:
        #     * 'networks'<~Array>:
        #       * 'bridge'<~String>
        #       * 'bridge_interface'<~String>
        #       * 'cidr'<~String>
        #       * 'created_at'<~Date>
        #       * 'deleted'<~Boolean>
        #       * 'deleted_at'<~Date>
        #       * 'dhcp_start'<~String>
        #       * 'dns1'<~String>
        #       * 'dns2'<~String>
        #       * 'gateway'<~String>
        #       * 'gateway_v6'<~String>
        #       * 'host'<~String>
        #       * 'id'<~UUID>
        #       * 'injected'<~Boolean>
        #       * 'label'<~String>
        #       * 'netmask'<~String>
        #       * 'netmask_v6'<~String>
        def list_networks
          request(
            :method  => 'GET',
            :expects => [200],
            :path    => "/os-networks"
          )
        end

      end

      class Mock
      end
    end
  end
end
