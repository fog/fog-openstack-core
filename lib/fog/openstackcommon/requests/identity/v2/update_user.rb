module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Real

          def update_user(id, options = {})
            # Identity service expects to see tenant id as 'tenantId'
            tenantId = options.delete(:tenant_id) || options.delete('tenant_id')
            options.merge!('id' => id, 'tenantId' => tenantId)

            request(
              :method   => 'PUT',
              :expects  => 200,
              :path     => "/users/#{id}",
              :body     => MultiJson.encode({ 'user' => options })
            )
          end

        end # Real

        class Mock
        end
      end # OpenStackCommon
    end # V2
  end # Identity
end # Fog
