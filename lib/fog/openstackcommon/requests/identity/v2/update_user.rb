module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def update_user(id, options = {})
          # Identity service expects to see tenant id as 'tenantId'
          tenantId = options.delete(:tenant_id) || options.delete('tenant_id')
          options.merge!('id' => id, 'tenantId' => tenantId)

          request(
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/v2.0/users/#{id}",
            :body     => MultiJson.encode({ 'user' => options }), 
            :admin    => true
          )
        end

      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
