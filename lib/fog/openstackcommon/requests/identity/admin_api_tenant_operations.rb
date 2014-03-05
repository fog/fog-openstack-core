module Fog
  module Identity
    class OpenStackCommon
      class Real

        def list_tenants(limit = nil, marker = nil)
          params = Hash.new
          params['limit']  = limit  if limit
          params['marker'] = marker if marker

          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => "/tenants",
            :query   => params
          )
        end

        def get_tenants_by_name(name)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/tenants?name=#{name}"
          )
        end

        def get_tenants_by_id(tenant_id)
          request(
            :expects  => [200, 204],
            :method   => 'GET',
            :path     => "/tenants/#{tenant_id}"
          )
        end

        def list_roles_for_user_on_tenant(tenant_id, user_id)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/tenants/#{tenant_id}/users/#{user_id}/roles"
          )
        end

      end

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
