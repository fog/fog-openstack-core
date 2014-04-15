module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def list_roles
          admin_request(
            :method  => 'GET',
            :expects => 200,
            :path    => '/v2.0/OS-KSADM/roles',
          )
        end

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # IdentityV2
end # Fog
