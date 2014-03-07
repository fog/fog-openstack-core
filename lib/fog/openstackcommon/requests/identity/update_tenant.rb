module Fog
  module Identity
    class OpenStackCommon
      class Real

        def update_tenant(id, attributes)
          request(
            :method  => 'POST',
            :expects => [200],
            :path    => "/tenants/#{id}",
            :body    => MultiJson.encode({ 'tenant' => attributes })
          )
        end # def update_tenant

        # class Mock
        #   def update_tenant(id, attributes)
        #     response = Excon::Response.new
        #     response.status = [200, 204][rand(1)]
        #     attributes = {'enabled' => true, 'id' => '1'}.merge(attributes)
        #     response.body = {
        #       'tenant' => attributes
        #     }
        #     response
        #   end # def update_tenant
        # end # class Mock

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
