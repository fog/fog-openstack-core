require 'fog/core/collection'
require 'fog/openstackcore/models/identity/v2/tenant'

module Fog
  module OpenStackCore
    class IdentityV2
      class Tenants < Fog::Collection
        model Fog::OpenStackCore::IdentityV2::Tenant

        def all
          load(service.list_tenants.body['tenants'])
        end

        def destroy(id)
          tenant = self.find_by_id(id)
          tenant.destroy
        end

      end # Tenants
    end # IdentityV2
  end # OpenStackCore
end # module Fog
