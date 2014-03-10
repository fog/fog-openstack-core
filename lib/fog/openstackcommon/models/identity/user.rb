require 'fog/core/model'

module Fog
  module Identity
    class OpenStackCommon
      class User < Fog::Model
        identity :id

        attribute :email
        attribute :enabled
        attribute :name
        attribute :tenant_id, :aliases => 'tenantId'
        attribute :password

        attr_accessor :email, :name, :tenant_id, :enabled, :password

        def initialize(attributes)
          # Old 'connection' is renamed as service and should be used instead
          prepare_service_value(attributes)
          super
        end

        def save
          requires :name, :tenant_id, :password
          enabled = true if enabled.nil?
          identity ? update : create
        end

        def create
          data = service.create_user(name, password, email, tenant_id, enabled)
          merge_attributes(data.body['user'])
          true
        end

        def update(options = {})
          requires :id
          options.merge('id' => id)
          merge_attributes(
            service.update_user(self.id, options || attributes).body['user'])
          true
        end

        def update_password(password)
          update({'password' => password})
        end

        def update_tenant(tenant)
          tenant = tenant.id if tenant.class != String
          update({:tenantId => tenant})
        end

        def update_enabled(enabled)
          requires :id
          update({:enabled => enabled})
        end

        def destroy
          requires :id
          service.delete_user(id)
          true
        end

        def ec2_credentials
          requires :id
          service.ec2_credentials(:user => self)
        end

        def roles(tenant_id = self.tenant_id)
          puts "TENANTID: #{self.tenant_id}"
          puts "USERID: #{self.id}"
          result = service.list_roles_for_user_on_tenant(tenant_id, self.id)
          result.body['roles']
        end
      end # class User
    end # class OpenStack
  end # module Identity
end # module Fog
