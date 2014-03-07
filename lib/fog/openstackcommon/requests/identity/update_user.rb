require 'multi_json'

module Fog
  module Identity
    class OpenStackCommon
      class Real

        def update_user(user_id, options = {})
          request(
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/users/#{user_id}",
            :body     => MultiJson.encode({ 'user' => options })
          )
        end

        # class Mock
        #
        #   def update_user(user_id, options)
        #     response = Excon::Response.new
        #     if user = self.data[:users][user_id]
        #       if options['name']
        #         user['name'] = options['name']
        #       end
        #       response.status = 200
        #       response
        #     else
        #       raise Fog::Identity::OpenStackCommon::NotFound
        #     end
        #   end
        #
        # end # Mock

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
