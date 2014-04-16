module Fog
  module OpenStackCore
    class IdentityV2
      class Real

        ##
        # Create an EC2 credential for a user in a tenant.  Requires
        # administrator credentials.
        #
        # ==== Parameters
        # * user_id<~String>: The id of the user to create an EC2 credential
        #   for
        # * tenant_id<~String>: The id of the tenant to create the credential
        #   in
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'credential'<~Hash>: Created EC2 credential
        #       * 'access'<~String>: The access key
        #       * 'secret'<~String>: The secret key
        #       * 'user_id'<~String>: The user id
        #       * 'tenant_id'<~String>: The tenant id

        def create_ec2_credential(user_id, tenant_id)
          data = { 'tenant_id' => tenant_id }
          admin_request(
            :method  => 'POST',
            :expects => [200, 202],
            :path    => "/v2.0/users/#{user_id}/credentials/OS-EC2",
            :body    => MultiJson.encode(data),
          )
        end

      end

      class Mock
      end
    end # IdentityV2
  end # OpenStackCore
end # Fog
