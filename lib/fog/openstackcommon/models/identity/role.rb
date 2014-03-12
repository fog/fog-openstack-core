require 'fog/core/model'

module Fog
  module Identity
    class OpenStackCommon
      class Role < Fog::Model
        identity :id
        attribute :name

        def initialize(attributes)
          prepare_service_value(attributes)
          super
        end

        def save
          requires :name
          data = service.create_role(name)
          merge_attributes(data.body['role'])
          true
        end

        def destroy
          requires :id
          service.delete_role(id)
          true
        end

        def add_to_user(user, tenant)
          add_or_remove_from_user(user, tenant, :add)
        end

        def remove_from_user(user, tenant)
          add_or_remove_from_user(user, tenant, :remove)
        end

        private
        def add_or_remove_from_user(user, tenant, ops)
          requires :id
          user_id = get_id(user)
          tenant_id = get_id(tenant)
          case ops
          when :add
            service.add_role_to_user_on_tenant(tenant_id, user_id, id).status == 200
          when :remove
            service.delete_user_role(tenant_id, user_id, id).status == 204
          end
        end

        def get_id(_)
          _.is_a?(String) ? _ : _.id
        end
      end # class Role
    end # class OpenStack
  end # module Identity
end # module Fog
