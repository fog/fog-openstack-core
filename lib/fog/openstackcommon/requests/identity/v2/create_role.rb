module Fog
  module Identity
    class OpenStackCommon
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
            :path   => '/OS-KSADM/roles',
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
    end # OpenStackCommon
  end # Identity
end # Fog
