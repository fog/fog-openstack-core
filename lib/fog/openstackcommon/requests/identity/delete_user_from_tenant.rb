module Fog
  module Identity
    class OpenStackCommon
      class Real

        def delete_user_from_tenant(tenant_id, user_id, role_id)
          request(
            :expects => [200, 204],
            :method  => 'DELETE',
            :path    => "/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}"
          )
        end

        # class Mock
        #   def delete_user_role(tenant_id, user_id, role_id)
        #     response = Excon::Response.new
        #     response.status = 204
        #     response
        #   end
        # end

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
