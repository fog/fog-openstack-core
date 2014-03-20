module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Real

          def get_tenants_by_id(tenant_id)
            request(
              :method   => 'GET',
              :expects  => [200, 204],
              :path     => "/tenants/#{tenant_id}"
            )
          end

        end

        class Mock
        end
      end # OpenStackCommon
    end # V2
  end # Identity
end # Fog
