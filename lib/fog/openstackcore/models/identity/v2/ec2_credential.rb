require 'fog/core/model'

module Fog
  module OpenStackCommon
    class IdentityV2
      class Ec2Credential < Fog::Model
        identity :access, :aliases => 'access_key'

        attribute :secret, :aliases => 'secret_key'
        attribute :tenant_id
        attribute :user_id

        def destroy
          requires :access, :user_id
          service.delete_ec2_credential(user_id, access)
          true
        end

        def save
          raise Fog::Errors::Error, 'Existing credentials cannot be altered' if access

          requires :user_id, :tenant_id

          data = service.create_ec2_credential(self.user_id, self.tenant_id)
          merge_attributes(data.body['credential'])
          true
        end
      end
    end
  end
end
