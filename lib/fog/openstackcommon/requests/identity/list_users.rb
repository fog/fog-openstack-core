require 'multi_json'

module Fog
  module Identity
    class OpenStackCommon
      class Real

        def list_users
          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => '/users'
          )
        end

        # class Mock
        #   def list_users(tenant_id = nil)
        #     users = self.data[:users].values
        #
        #     if tenant_id
        #       users = users.select {
        #         |user| user['tenantId'] == tenant_id
        #       }
        #     end
        #
        #
        #     Excon::Response.new(
        #       :body   => { 'users' => users },
        #       :status => 200
        #     )
        #   end
        # end # class Mock

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
