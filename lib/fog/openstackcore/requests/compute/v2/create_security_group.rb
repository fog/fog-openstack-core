module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Create a security group
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'name'<~String> - Name of the security group
        #   * 'description'<~String> - Description of the security group

        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'security_group'<~Array>:
        #     * 'id'<~String> - UUId of the security group
        #     * 'name'<~String> - Name of the security group
        #     * 'description'<~String> - Description of the security group
        #     * 'tenant_id'<~String> - Tenant id that owns the security group
        #     * 'security_group_rules'<~Array>: - Array of security group rules
        #       * 'id'<~String> - UUId of the security group rule
        #       * 'direction'<~String> - Direction of traffic, must be in ['ingress', 'egress']
        #       * 'port_range_min'<~Integer> - Start port for rule i.e. 22 (or -1 for ICMP wildcard)
        #       * 'port_range_max'<~Integer> - End port for rule i.e. 22 (or -1 for ICMP wildcard)
        #       * 'protocol'<~String> - IP protocol for rule, must be in ['tcp', 'udp', 'icmp']
        #       * 'ethertype'<~String> - Type of ethernet support, must be in ['IPv4', 'IPv6']
        #       * 'security_group_id'<~String> - UUId of the parent security group
        #       * 'remote_group_id'<~String> - UUId of the remote security group
        #       * 'remote_ip_prefix'<~String> - IP cidr range address i.e. '0.0.0.0/0'
        #       * 'tenant_id'<~String> - Tenant id that owns the security group rule

        #TODO DOCS BAD!!! Example 4.305. Create security group: JSON request is wrong
        #{
        #"addSecurityGroup" : {
        #  "name" : "test"
        #}
        #}

        def create_security_group(options = {})

          data = {'security_group' => {}}

          l_options = [:name, :description]
          l_options.select { |o| options[o] }.each do |key|
            data['security_group'][key] = options[key]
          end

          request(
            :expects => 200,
            :method  => 'POST',
            :path    => "os-security-groups ",
            :body => Fog::JSON.encode(data)
          )
        end
      end

      class Mock
      end
    end
  end
end
