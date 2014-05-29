module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List floating IP addresses available
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'floating_ips'<~Array>:
        #     * 'instance_id'<~UUID>
        #     * 'ip'<~String>
        #     * 'fixed_ip'<~String>
        #     * 'id'<~UUID>
        #     * 'pool'<~String>
        def list_floating_ips
          request(
            :method  => 'GET',
            :expects => [200],
            :path    => "/os-floating-ips"
          )
        end

      end

      class Mock
      end
    end
  end
end
