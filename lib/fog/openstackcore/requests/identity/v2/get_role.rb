module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def get_role(id)
          admin_request(
            :method  => 'GET',
            :expects => [200, 204],
            :path    => "/v2.0/OS-KSADM/roles/#{id}",
          )
        end

      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
