module Fog
  module Identity
    class OpenStackCommon
      class Real

        def get_tenants_by_name(name)
          request(
            :method   => 'GET',
            :expects  => [200],
            :path     => "/tenants?name=#{name}"
          )
        end

      end

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
