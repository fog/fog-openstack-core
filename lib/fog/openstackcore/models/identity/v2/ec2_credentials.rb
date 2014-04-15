require 'fog/core/collection'
require 'fog/OpenStackCore/models/identity/v2/ec2_credential'

module Fog
  module OpenStackCore
    class IdentityV2
      class Ec2Credentials < Fog::Collection
        model Fog::OpenStackCore::IdentityV2::Ec2Credentials

        attribute :user

        def all
          return [] unless user
          ec2_credentials = service.list_ec2_credentials(user.id)
          load(ec2_credentials.body['credentials'])
        end

        def create(attributes = {})
          if user then
            attributes[:user_id]   ||= user.id
            attributes[:tenant_id] ||= user.tenant_id
          end
          super
        end

        def destroy(access_key)
          ec2_credential = self.find_by_access_key(access_key)
          ec2_credential.destroy
        end

      end  # Ec2Credentials
    end  # OpenStackCore
  end  # IdentityV2
end  # Fog
