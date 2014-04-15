require 'fog/core/model'

module Fog
  module OpenStackCommon
    class IdentityV2
      class Tenant < Fog::Model
        identity :id

        attribute :description
        attribute :enabled
        attribute :name

        def save
          requires :name
          persisted? ? update : create
        end

        def destroy
          requires :id
          service.delete_tenant(self.id)
          true
        end

        def users
          requires :id
          service.users(:tenant_id => self.id)
        end

        def to_s
          self.name
        end

        private

        def create
          data = service.create_tenant(attributes)
          merge_attributes(data.body['tenant'])
          true
        end

        def update
          requires :id
          data = service.update_tenant(self.id, attributes)
          merge_attributes(data.body['tenant'])
          true
        end

      end # Tenant
    end # IdentityV2
  end # OpenStackCommon
end # Fog
