module Fog
  module OpenStackCore
    class ComputeV2
      class Real


        # Delete a security group rule
        #
        # ==== Parameters
        # * 'security_group_rule_id'<~String> - UUId of the security group rule to delete
        def delete_security_group_rule(security_group_rule_id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :path    => "os-security-group-rules/#{security_group_rule_id}"
          )
        end
      end

      class Mock
      end
    end
  end
end
