module Fog
  module Identity
    class OpenStackCommon
      class Real

        def delete_role(role_id)
          request(
            :expects => [200, 204],
            :method => 'DELETE',
            :path   => "/OS-KSADM/roles/#{role_id}"
          )
        end

        # class Mock
        #   def delete_role(role_id)
        #     response = Excon::Response.new
        #     if self.data[:roles][role_id]
        #       self.data[:roles].delete(role_id)
        #       response.status = 204
        #       response
        #     else
        #       raise Fog::Identity::OpenStackCommon::NotFound
        #     end
        #   end
        # end

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
