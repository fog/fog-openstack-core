module Fog
  module Identity
    class OpenStackCommon
      class Real

        def list_roles
          request(
            :method => 'GET',
            :expects => 200,
            :path   => '/OS-KSADM/roles'
          )
        end

        # class Mock
        #   def list_roles
        #     if self.data[:roles].empty?
        #       ['admin', 'Member'].each do |name|
        #         id = Fog::Mock.random_hex(32)
        #         self.data[:roles][id] = {'id' => id, 'name' => name}
        #       end
        #     end
        #     Excon::Response.new(
        #       :body   => { 'roles' => self.data[:roles].values },
        #       :status => 200
        #     )
        #   end
        # end

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
