module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Delete a security group
        # ==== Normal Response Codes
        # * 200
        # ==== Error Response Codes
        #
        # * unauthorized (401)
        # * itemNotFound (404)
        #
        # @param security_group_id [UUID] UUID of the security group to delete

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
