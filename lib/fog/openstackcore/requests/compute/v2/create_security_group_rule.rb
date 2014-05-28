module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Create a new security group rule
        #
        # ==== Normal Response Codes
        # * 200
        #
        # ==== Error Response Codes
        # * badRequest (400)
        # * unauthorized (401)
        # * itemNotFound (404)
        # * buildInProgress (409)
        #
        # ==== Parameters
        # * 'parent_group_id'<~String> - UUId of the parent security group
        # * 'from_port'<~Integer> - Start port for rule i.e. 22 (or -1 for ICMP wildcard)
        # * 'to_port'<~Integer> - End port for rule i.e. 22 (or -1 for ICMP wildcard)
        # * 'ip_protocol'<~String> - IP protocol for rule, must be in ['tcp', 'udp', 'icmp']
        # * 'group_id'<~String> - UUId of the remote security group
        # * 'cidr'<~String> - IP cidr range address i.e. '0.0.0.0/0'
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'security_group_rule'<~Hash>:
        #     * 'id'<~String> - UUId of the security group rule
        #     * 'from_port'<~String> - Start port for rule i.e. 22 (or -1 for ICMP wildcard)
        #     * 'to_port'<~String> - End port for rule i.e. 22 (or -1 for ICMP wildcard)
        #     * 'ip_protocol'<~String> - IP protocol for rule, must be in ['tcp', 'udp', 'icmp']
        #     * 'parent_group_id'<~String> - UUId of the parent security group
        #     * 'ip_range'<~Hash>:
        #       *cidr<~String>  - IP cidr range address i.e. '0.0.0.0/0'
        #
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
