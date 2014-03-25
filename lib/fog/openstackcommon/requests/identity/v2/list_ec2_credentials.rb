module Fog
  module Identity
    module V2
      class OpenStackCommon
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
            request(
              :method  => 'GET',
              :expects => [200, 202],
              :path    => "/users/#{user_id}/credentials/OS-EC2"
            )
          end

        end

        class Mock
        end
      end # OpenStackCommon
    end # V2
  end # Identity
end # Fog
