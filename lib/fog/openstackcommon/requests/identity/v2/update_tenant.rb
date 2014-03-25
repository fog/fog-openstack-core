module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Real

          def update_tenant(id, attributes)
            attributes.merge!('id' => id)
            request(
              :method  => 'POST',
              :expects => [200],
              :path    => "/tenants/#{id}",
              :body    => MultiJson.encode({ 'tenant' => attributes })
            )
          end # def update_tenant

        end # Real

        class Mock
        end
      end # OpenStackCommon
    end # V2
  end # Identity
end # Fog
