require 'fog/core/collection'
require 'fog/openstackcore/models/identity/v2/role'

module Fog
  module OpenStackCore
    class IdentityV2
      class Roles < Fog::Collection
        model Fog::OpenStackCore::IdentityV2::Role

        def all
          load(service.list_roles.body['roles'])
        end

      end
    end # IdentityV2
  end # OpenStackCore
end # module Fog
