module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Delete a security group
        #
        # ==== Parameters
        # * 'security_group_id'<~String> - UUId of the security group to delete

        def delete_security_group(security_group_id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :path    => "os-security-groups/#{security_group_id}"
          )
        end
      end

      class Mock
      end
    end
  end
end
