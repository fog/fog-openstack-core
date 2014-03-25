module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Real

          def get_role(id)
            request(
              :method  => 'GET',
              :expects => [200, 204],
              :path    => "/OS-KSADM/roles/#{id}"
            )
          end

          # class Mock
          #   def get_role(id)
          #     response = Excon::Response.new
          #     if data = self.data[:roles][id]
          #       response.status = 200
          #       response.body = { 'role' => data }
          #       response
          #     else
          #       raise Fog::Identity::OpenStackCommon::NotFound
          #     end
          #   end
          # end # class Mock

        end # Real

        class Mock
        end
      end # OpenStackCommon
    end # V2
  end # Identity
end # Fog
