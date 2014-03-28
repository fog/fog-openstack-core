module Fog
  module OpenStackCommon
    class IdentityV2
      class Real

        def create_role(name)
          data = {
            'role' => {
              'name' => name
            }
          }
          request(
            :method   => 'POST',
            :expects  => [200, 202],
            :path   => '/v2.0/OS-KSADM/roles',
            :body     => MultiJson.encode(data)
          )
        end

        # class Mock
        #   def create_role(name)
        #     data = {
        #       'id'   => Fog::Mock.random_hex(32),
        #       'name' => name
        #     }
        #     self.data[:roles][data['id']] = data
        #     Excon::Response.new(
        #       :body   => { 'role' => data },
        #       :status => 202
        #     )
        #   end
        # end

      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
