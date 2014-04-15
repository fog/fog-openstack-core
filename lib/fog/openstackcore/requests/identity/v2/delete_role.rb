module Fog
  module OpenStackCore
    class IdentityV2
      class Real

        def delete_role(role_id)
          admin_request(
            :method  => 'DELETE',
            :expects => [200, 204],
            :path    => "/v2.0/OS-KSADM/roles/#{role_id}",
          )
        end

      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCore
end # Fog
