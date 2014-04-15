module Fog
  module OpenStackCore
    class IdentityV2
      class Real

        ##
        # Retrieves an EC2 credential for a user.  Requires administrator
        # credentials.
        #
        # ==== Parameters
        # * user_id<~String>: The id of the user to retrieve the credential
        #   for
        # * access<~String>: The access key of the credential to retrieve
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'credential'<~Hash>: The EC2 credential
        #       * 'access'<~String>: The access key
        #       * 'secret'<~String>: The secret key
        #       * 'user_id'<~String>: The user id
        #       * 'tenant_id'<~String>: The tenant id

        def get_ec2_credential(user_id, access)
          admin_request(
            :method  => 'GET',
            :expects => [200, 202],
            :path    => "/v2.0/users/#{user_id}/credentials/OS-EC2/#{access}",
          )
        end

      end

      class Mock
      end
    end # IdentityV2
  end # OpenStackCore
end # Fog
