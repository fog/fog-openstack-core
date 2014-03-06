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
            :body     => MultiJson.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path   => '/OS-KSADM/roles'
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
