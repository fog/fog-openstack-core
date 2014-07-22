module Fog
 module OpenStackCore
  class ComputeV2
      class Real
        # Add an existing security group to an existing server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server
        # * 'sg_name'<~String> - Name of security group to add to the server
        #
        def add_security_group(server_id, sg_name)
          body = { 'addSecurityGroup' => { 'name' => sg_name }}
          server_action(server_id, body)
        end
      end
  end

  end
end
