module Fog
  module OpenStackCommon
    class IdentityV1 < Fog::Service

      requires :openstack_auth_url,
               :openstack_username,
               :openstack_api_key
      recognizes :openstack_auth_token, :openstack_management_url, :persistent,
                  :openstack_service_type, :openstack_service_name, :openstack_tenant,
                  :openstack_api_key, :openstack_username, :openstack_current_user_id,
                  :openstack_endpoint_type,
                  :current_user, :current_tenant

      request_path 'fog/openstackcommon/requests/identity/v1'

      ## Token Operations
      request :create_token
      request :check_token
      request :validate_token
      request :list_endpoints_for_token

      # minimal requirement
      class Mock
      end

      class Real
      end  # Real

    end  # IdentityV1
  end   # OpenStackCommon
end   # Fog
