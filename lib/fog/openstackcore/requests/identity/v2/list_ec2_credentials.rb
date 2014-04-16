module Fog
  module OpenStackCore
    class IdentityV2
      class Real

        ##
        # List EC2 credentials for a user.  Requires administrator
        # credentials.
        #
        # ==== Parameters
        # * user_id<~String>: The id of the user to retrieve the credential
        #   for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'credentials'<~Array>: The user's EC2 credentials
        #       * 'access'<~String>: The access key
        #       * 'secret'<~String>: The secret key
        #       * 'user_id'<~String>: The user id
        #       * 'tenant_id'<~String>: The tenant id

        def list_ec2_credentials(user_id)
          admin_request(
            :method  => 'GET',
            :expects => [200, 202],
            :path    => "/v2.0/users/#{user_id}/credentials/OS-EC2",
          )
        end

      end

      class Mock
      end
    end # IdentityV2
  end # OpenStackCore
end # Fog
