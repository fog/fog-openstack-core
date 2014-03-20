require 'fog/core/collection'
require 'fog/openstackcommon/models/identity/v2/user'

module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Users < Fog::Collection
          model Fog::Identity::OpenStackCommon::User

          attribute :tenant_id

          def all
            users_list = service.list_users_for_tenant(tenant_id)
            load(users_list.body['users'])
          end

          def destroy(id)
            user = self.find_by_id(id)
            user.destroy
          end

        end # class Users
      end # class OpenStack
    end # V2
  end # module Identity
end # module Fog
