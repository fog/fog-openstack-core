require 'fog/core/collection'
require 'fog/openstackcore/models/identity/v2/user'

module Fog
  module OpenStackCore
    class IdentityV2
      class Users < Fog::Collection
        model Fog::OpenStackCore::IdentityV2::User

        attribute :tenant_id

        def all
          users_list = service.list_users_for_tenant(tenant_id)
          load(users_list.body['users'])
        end

        def destroy(id)
          user = self.find_by_id(id)
          user.destroy
        end

      end # Users
    end # IdentityV2
  end # OpenStackCore
end # Fog
