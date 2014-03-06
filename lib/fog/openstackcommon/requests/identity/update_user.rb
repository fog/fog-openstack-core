require 'multi_json'

module Fog
  module Identity
    class OpenStackCommon
      class Real

        def update_user(user_id, options = {})
          url = options.delete('url') || "/users/#{user_id}"
          request(
            :body     => Fog::JSON.encode({ 'user' => options }),
            :expects  => 200,
            :method   => 'PUT',
            :path     => url
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
