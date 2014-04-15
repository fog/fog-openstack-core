require 'fog/core/collection'
require 'fog/openstackcommon/models/identity/v2/role'

module Fog
  module OpenStackCommon
    class IdentityV2
      class Roles < Fog::Collection
        model Fog::OpenStackCommon::IdentityV2::Role

        def all
          load(service.list_roles.body['roles'])
        end

      end
    end # IdentityV2
  end # OpenStackCommon
end # module Fog
