module Fog
  module Identity
    class OpenStackCommon
      class Real

        def get_tenants_by_id(tenant_id)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "tenants/#{tenant_id}"
          )
        end

      end

      class Mock



      end
    end # OpenStackCommon
  end # Identity
end # Fog
