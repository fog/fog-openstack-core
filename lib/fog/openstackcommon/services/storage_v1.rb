module Fog
  module OpenStackCommon
    class StorageV1 < Fog::Service
      requires :openstack_auth_url,
               :openstack_username,
               :openstack_api_key
      recognizes :openstack_auth_token, :openstack_management_url, :persistent,
                  :openstack_service_type, :openstack_service_name, :openstack_tenant,
                  :openstack_api_key, :openstack_username, :openstack_current_user_id,
                  :openstack_endpoint_type,
                  :current_user, :current_tenant

      request_path 'fog/openstackcommon/requests/storage/v1'

      # Containers
      request :head_containers
      request :get_container
      request :delete_container
      request :get_container

      # Files
      request :head_object
      request :get_object
      request :delete_object
      request :get_object

      # minimal requirement
      class Mock
        def initialize(params); end
      end

      class Real
        def initialize(params)
          identity = Fog::Identity.new(params)
          self.token = identity.auth_token
        end
      end 

    end
  end
end
