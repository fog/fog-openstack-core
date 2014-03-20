require 'fog/core/collection'
require 'fog/openstackcommon/models/identity/v2/role'

module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Roles < Fog::Collection
          model Fog::Identity::OpenStackCommon::Role

          def all
            load(service.list_roles.body['roles'])
          end

        end
      end # class OpenStack
    end # V2
  end # module Compute
end # module Fog
