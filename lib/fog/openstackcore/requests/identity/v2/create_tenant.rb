module Fog
  module OpenStackCommon
    class IdentityV2
      class Real
        def create_tenant(attributes={})
          attributes ||= {}
          admin_request(
            :method  => 'POST',
            :expects => [200, 201, 202],
            :path    => '/v2.0/tenants',
            :body    =>  MultiJson.encode({'tenant' => attributes}),
          )
        end
      end # Real

      class Mock
      end
    end # IdentityV2
  end # OpenStackCommon
end # Fog
