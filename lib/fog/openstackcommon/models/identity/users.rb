require 'fog/core/collection'
require 'fog/openstackcommon/models/identity/user'

module Fog
  module Identity
    class OpenStackCommon
      class Users < Fog::Collection
        model Fog::Identity::OpenStackCommon::User

        attribute :tenant_id

        def all
          users_list = service.list_users_for_tenant(tenant_id)
          load(users_list.body['users'])
        end

        def find_by_id(id)
          find_user_in_collection(id) || build_user(id)
        end

        def destroy(id)
          user = self.find_by_id(id)
          user.destroy
        end

        private

        def find_user_in_collection(id)
          self.find {|user| user.id == id}
        end

        def build_user(id)
          Fog::Identity::OpenStackCommon::User.new(
            service.get_user_by_id(id).body['user'].merge(
              'service' => service
            )
          )
        end

      end # class Users
    end # class OpenStack
  end # module Identity
end # module Fog
