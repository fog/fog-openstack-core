require 'fog/core/collection'
require 'fog/openstackcommon/models/identity/v2/user'

module Fog
  module OpenStackCommon
    class IdentityV2
      class Users < Fog::Collection
        model Fog::Identity::V2::OpenStackCommon::User

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
  end # OpenStackCommon
end # Fog
