require 'fog/core/model'

module Fog
  module OpenStackCommon
    class IdentityV2
      class User < Fog::Model
        identity :id

        attribute :name
        attribute :tenant_id, :aliases => 'tenantId'
        attribute :password
        attribute :email
        attribute :enabled

        def save
          requires :name, :tenant_id, :password
          self.enabled = true if self.enabled.nil?
          persisted? ? update : create
        end

        def destroy
          requires :id
          service.delete_user(self.id)
          true
        end

        def ec2_credentials
          requires :id
          service.ec2_credentials(:user => self)
        end

        def roles(tenant_id = self.tenant_id)
          data = service.list_roles_for_user_on_tenant(tenant_id, self.id)
          data.body['roles']
        end

        def grant_role(role_id)
          service.add_role_to_user_on_tenant(
            tenant_id = self.tenant_id, self.id, role_id)
        end

        def revoke_role(role_id)
          service.delete_role_from_user_on_tenant(
            tenant_id = self.tenant_id, self.id, role_id)
        end

        private

        def create
          data = service.create_user(name, password, email, tenant_id, enabled)
          merge_attributes(data.body['user'])
          true
        end

        def update
          requires :id
          data = service.update_user(self.id, attributes)
          merge_attributes(data.body['user'])
          true
        end

      end # User
    end # IdentityV2
  end # OpenStackCommon
end # module Fog
