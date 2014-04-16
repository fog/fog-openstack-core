require 'fog/core/model'

module Fog
  module OpenStackCore
    class IdentityV2
      class Role < Fog::Model
        identity :id
        attribute :name

        def save
          requires :name
          persisted? ? update : create
        end

        def destroy
          requires :id
          service.delete_role(id)
          true
        end

        private

        def create
          data = service.create_role(name)
          merge_attributes(data.body['role'])
          true
        end

        def update
          raise "The Role model doesn't support Update operation."
        end

      end # Role
    end # IdentityV2
  end # OpenStackCore
end # Fog
