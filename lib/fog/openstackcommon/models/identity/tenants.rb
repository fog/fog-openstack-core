require 'fog/core/collection'
require 'fog/openstackcommon/models/identity/tenant'

module Fog
  module Identity
    class OpenStackCommon
      class Tenants < Fog::Collection
        model Fog::Identity::OpenStackCommon::Tenant

        def all
          load(service.list_tenants.body['tenants'])
        end

        def destroy(id)
          tenant = self.find_by_id(id)
          tenant.destroy
        end

      end # class Tenants
    end # class OpenStack
  end # module Compute
end # module Fog
