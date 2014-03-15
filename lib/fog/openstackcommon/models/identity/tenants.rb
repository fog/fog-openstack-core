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

        def find_by_id(id)
          find_tenant_in_collection(id) || build_tenant(id)
        end

        def destroy(id)
          tenant = self.find_by_id(id)
          tenant.destroy
        end

        private

        def find_tenant_in_collection(id)
          self.find {|tenant| tenant.id == id}
        end

        def build_tenant(id)
          Fog::Identity::OpenStackCommon::Tenant.new(
            service.get_tenant(id).body['tenant'].merge(
              'service' => service
            )
          )
        end

      end # class Tenants
    end # class OpenStack
  end # module Compute
end # module Fog
