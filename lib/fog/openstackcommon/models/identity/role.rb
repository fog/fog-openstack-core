require 'fog/core/model'

module Fog
  module Identity
    class OpenStackCommon
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

        # api doesnt support update at this time, but need
        # to protect against updates
        def update
          false
        end

      end # class Role
    end # class OpenStack
  end # module Identity
end # module Fog
