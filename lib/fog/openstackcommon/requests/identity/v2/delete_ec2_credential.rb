module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        ##
        # Destroy an EC2 credential for a user.  Requires administrator
        # credentials.
        #
        # ==== Parameters
        # * user_id<~String>: The id of the user to delete the credential
        #   for
        # * access<~String>: The access key of the credential to destroy
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String>:  Empty string

        def delete_ec2_credential(user_id, access)
          request(
            :method  => 'DELETE',
            :expects => [200, 204],
            :path    => "/v2.0/users/#{user_id}/credentials/OS-EC2/#{access}"
          )
        end

      end

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
