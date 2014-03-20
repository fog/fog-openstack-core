module Fog
  module Identity
    module V2
      class OpenStackCommon
        class Real
          def create_tenant(attributes={})
            attributes ||= {}
            request(
              :method  => 'POST',
              :expects => [200, 201, 202],
              :path    => '/tenants',
              :body    =>  MultiJson.encode({'tenant' => attributes})
            )
          end
        end # Real

        class Mock
        end
      end # OpenStackCommon
    end # V2
  end # Identity
end # Fog
