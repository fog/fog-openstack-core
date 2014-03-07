module Fog
  module Identity
    class OpenStackCommon
      class Real

        def delete_tenant(id)
          request(
            :expects => [200, 204],
            :method  => 'DELETE',
            :path    => "/tenants/#{id}"
          )
        end

        # class Mock
        #   def delete_tenant(attributes)
        #     response = Excon::Response.new
        #     response.status = [200, 204][rand(1)]
        #     response.body = {
        #       'tenant' => {
        #         'id' => '1',
        #         'description' => 'Has access to everything',
        #         'enabled' => true,
        #         'name' => 'admin'
        #       }
        #     }
        #     response
        #   end
        # end # class Mock

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
