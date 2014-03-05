module Fog
  module Identity
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
            :expects => [200, 202],
            :method  => 'GET',
            :path    => "/users/#{user_id}/credentials/OS-EC2"
          )
        end

        # class Mock
        #   def list_ec2_credentials(user_id)
        #     ec2_credentials = self.data[:ec2_credentials][user_id].values
        #
        #     response = Excon::Response.new
        #     response.status = 200
        #     response.body = { 'credentials' => ec2_credentials }
        #     response
        #   end
        # end




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
          request(
            :expects => [200, 202],
            :method  => 'GET',
            :path    => "/users/#{user_id}/credentials/OS-EC2/#{access}"
          )
        rescue Excon::Errors::Unauthorized
          raise Fog::Identity::OpenStackCommon::NotFound
        end

        # class Mock
        #   def get_ec2_credential(user_id, access)
        #     ec2_credential = self.data[:ec2_credentials][user_id][access]
        #
        #     raise Fog::OpenStackCommon::Identity::NotFound unless ec2_credential
        #
        #     response = Excon::Response.new
        #     response.status = 200
        #     response.body = { 'credential' => ec2_credential }
        #     response
        #   end
        # end






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

          request(
            :body    => Fog::JSON.encode(data),
            :expects => [200, 202],
            :method  => 'POST',
            :path    => "users/#{user_id}/credentials/OS-EC2"
          )
        end

        # class Mock
        #   def create_ec2_credential(user_id, tenant_id)
        #     response = Excon::Response.new
        #     response.status = 200
        #
        #     data = {
        #       'access'    => Fog::Mock.random_hex(32),
        #       'secret'    => Fog::Mock.random_hex(32),
        #       'tenant_id' => tenant_id,
        #       'user_id'   => user_id,
        #     }
        #
        #     self.data[:ec2_credentials][user_id][data['access']] = data
        #
        #     response.body = { 'credential' => data }
        #
        #     response
        #   end
        # end




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
            :expects => [200, 204],
            :method  => 'DELETE',
            :path    => "users/#{user_id}/credentials/OS-EC2/#{access}"
          )
        end

        # class Mock
        #   def delete_ec2_credential(user_id, access)
        #     raise Fog::Identity::OpenStackCommon::NotFound unless
        #       self.data[:ec2_credentials][user_id][access]
        #
        #     self.data[:ec2_credentials][user_id].delete access
        #
        #     response = Excon::Response.new
        #     response.status = 204
        #     response
        #   rescue
        #   end
        # end










      end

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
