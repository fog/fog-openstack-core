require 'fog/core/collection'
require 'fog/openstackcommon/models/identity/role'

module Fog
  module Identity
    class OpenStackCommon
      class Roles < Fog::Collection
        model Fog::Identity::OpenStackCommon::Role

        def all
          load(service.list_roles.body['roles'])
        end

      end
    end # class OpenStack
  end # module Compute
end # module Fog
