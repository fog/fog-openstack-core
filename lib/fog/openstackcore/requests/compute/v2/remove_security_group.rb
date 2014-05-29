

module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Remove an existing security group from an existing server
        #
        # ==== Parameters
        # * 'server_id'<~UUID> - UUId of server
        # * 'sg_name'<~String> - Name of security group to remove from the server
        #
        def remove_security_group(server_id, sg_name)
          body = {'removeSecurityGroup' => {'name' => sg_name}}
          server_action(server_id, body)
        end

      end

      class Mock
      end
    end
  end
end
