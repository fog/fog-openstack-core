require 'fog/core/collection'
require 'fog/openstackcommon/models/identity/ec2_credential'

module Fog
  module Identity
    class OpenStackCommon
      class Ec2Credentials < Fog::Collection
        model Fog::Identity::OpenStackCommon::Ec2Credential

        attribute :user

        def all
          user_id = user ? user.id : nil

          ec2_credentials = service.list_ec2_credentials(user_id)

          load(ec2_credentials.body['credentials'])
        end

        def create(attributes = {})
          if user then
            attributes[:user_id]   ||= user.id
            attributes[:tenant_id] ||= user.tenant_id
          end

          super attributes
        end

        def destroy(access_key)
          ec2_credential = self.find_by_access_key(access_key)
          ec2_credential.destroy
        end

        def find_by_access_key(access_key)
          user_id = user ? user.id : nil

          ec2_credential =
            self.find { |cred| cred.access == access_key }

          unless ec2_credential then
            response = service.get_ec2_credential(user_id, access_key)
            body = response.body['credential']
            body = body.merge 'service' => service

            ec2_credential = Fog::Identity::OpenStackCommon::EC2Credential.new(body)
          end

          ec2_credential
        end
      end
    end
  end
end
