require 'fog/core/model'

module Fog
  module Identity
    class OpenStackCommon
      class User < Fog::Model
        identity :id

        attribute :name
        attribute :tenant_id, :aliases => 'tenantId'
        attribute :password
        attribute :email
        attribute :enabled

        attr_accessor :name, :tenant_id, :password, :email, :enabled

        def save
          # raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :name, :tenant_id, :password
          enabled = true if enabled.nil?
          identity ? update : create
        end

        def create
          data = service.create_user(name, password, email, tenant_id, enabled)
          merge_attributes(data.body['user'])
          self
        end

        def update(options = {})
          requires :id
          data = service.update_user(self.id, options || attributes)
          merge_attributes(data.body['user'])
          self
        end

        def update_password(password)
          update({'password' => password})
        end

        def update_tenant(tenant)
          tenant = tenant.id if tenant.class != String
          update({'tenantId' => tenant})
        end

        def update_enabled(enabled)
          requires :id
          update({'enabled' => enabled})
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
      end # class User
    end # class OpenStack
  end # module Identity
end # module Fog
