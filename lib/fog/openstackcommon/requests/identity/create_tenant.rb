module Fog
  module Identity
    class OpenStackCommon
      class Real

        def create_tenant(name, description='', enabled=true)
          data = {
            'tenant' => {
              'name'        => name,
              'description' => description,
              'enabled'     => enabled
            }
          }

          request(
            :method  => 'POST',
            :path    => '/tenants',
            :body    =>  MultiJson.encode(data),
            :expects => [200, 201, 202]
          )
        end

      end # Real

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
