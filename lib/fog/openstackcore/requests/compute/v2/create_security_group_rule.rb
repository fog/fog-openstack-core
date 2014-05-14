module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Create a new security group rule
        #
        # ==== Parameters
        # * 'parent_group_id'<~String> - UUId of the parent security group
        # * options<~Hash>:
        #   * 'from_port'<~Integer> - Start port for rule i.e. 22 (or -1 for ICMP wildcard)
        #   * 'to_port'<~Integer> - End port for rule i.e. 22 (or -1 for ICMP wildcard)
        #   * 'ip_protocol'<~String> - IP protocol for rule, must be in ['tcp', 'udp', 'icmp']
        #   * 'group_id'<~String> - UUId of the remote security group
        #   * 'cidr'<~String> - IP cidr range address i.e. '0.0.0.0/0'
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'security_group_rule'<~Hash>:
        #     * 'id'<~String> - UUId of the security group rule
        #     * 'port_range_min'<~String> - Start port for rule i.e. 22 (or -1 for ICMP wildcard)
        #     * 'port_range_max'<~String> - End port for rule i.e. 22 (or -1 for ICMP wildcard)
        #     * 'protocol'<~String> - IP protocol for rule, must be in ['tcp', 'udp', 'icmp']
        #     * 'security_group_id'<~String> - UUId of the parent security group
        #     * 'remote_group_id'<~String> - UUId of the source security group
        #     * 'remote_ip_prefix'<~String> - IP cidr range address i.e. '0.0.0.0/0'


        def create_security_group_rule(parent_group_id, ip_protocol, from_port, to_port, cidr, group_id=nil)
          data = {
            'security_group_rule' => {
              'parent_group_id' => parent_group_id,
              'ip_protocol'     => ip_protocol,
              'from_port'       => from_port,
              'to_port'         => to_port,
              'cidr'            => cidr,
              'group_id'        => group_id
            }
          }

          request(
            :expects => 200,
            :method  => 'POST',
            :body    => Fog::JSON.encode(data),
            :path    => 'os-security-group-rules.json'
          )
        end

        class Mock
        end
      end
    end
  end

end
