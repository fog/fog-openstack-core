require 'fog/core/collection'
require 'fog/openstackcommon/models/identity/v2/tenant'

module Fog
  module OpenStackCommon
    class IdentityV2
      class Tenants < Fog::Collection
        model Fog::Identity::V2::OpenStackCommon::Tenant

        def all
          load(service.list_tenants.body['tenants'])
        end

        def destroy(id)
          tenant = self.find_by_id(id)
          tenant.destroy
        end

      end # Tenants
    end # IdentityV2
  end # OpenStackCommon
end # module Fog
