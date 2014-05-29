module Fog
  module OpenStackCore
    class ComputeV2
      class Real


        # Allocates a floating IP address
        #
        # ==== Normal Response Codes
        #   * 200
        # ==== Error Response Codes
        #   * 400 No floating ips available
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'floating_ip'<~Hash>:
        #     * 'instance_id'<~UUID>
        #     * 'ip'<~String>
        #     * 'fixed_ip'<~String>
        #     * 'id'<~UUID>
        #     * 'pool'<~String>
       def allocate_address()

          request(
            :body    =>nil,
            :expects => 200,
            :method  => 'POST',
            :path    => 'os-floating-ips.json'
          )
        end

      end

      class Mock
      end
    end
  end
end
