module Fog
  module Identity
    class OpenStackCommon
      class Real

        # ToDo: Migrate authenticate logic here possibly???
        # def authenticate
        # end

        def check_token(token_id, tenant_id)
          request(
            :expects  => [200, 203, 204],
            :method   => 'HEAD',
            :path     => "/tokens/#{token_id}?belongsTo=#{tenant_id}"
          )
        end

        def validate_token(token_id, tenant_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "/tokens/#{token_id}?belongsTo=#{tenant_id}"
          )
        end

        def list_endpoints_for_token(token_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "/tokens/#{token_id}/endpoints"
          )
        end

      end

      class Mock
      end
    end # OpenStackCommon
  end # Identity
end # Fog
