module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List security groups
        #
        # ==== Normal Response Codes
        #   * 202
        #
        # ==== Parameters
        # * options<~Hash>:

        # ==== Returns
        # * response<~Excon::Response> :
        #   * body<~Hash>:
        #     * 'security_groups'<~Array>:
        #       * 'id'<~String> - UUId of the security group
        #       * 'name'<~String> - Name of the security group
        #       * 'description'<~String> - Description of the security group
        #       * 'tenant_id'<~String> - Tenant id that owns the security group
        #       * 'security_group_rules'<~Array>: - Array of security group rules
        def list_security_groups(options={})

          request(
            :method  => 'GET',
            :expects => [200],
            :path    => "/os-security-groups",
            :query   => options
          )
        end

      end

      class Mock
      end
    end
  end
end
