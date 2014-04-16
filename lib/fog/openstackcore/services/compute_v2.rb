require 'fog/openstackcore/request_common'
require 'fog/openstackcore/service_catalog'

module Fog
  module OpenStackCore
    class ComputeV2 < Fog::Service

      requires :openstack_auth_url
      recognizes :openstack_username, :openstack_api_key,
                 :openstack_auth_token, :persistent,
                 :openstack_tenant, :openstack_region

      ## MODELS
      #
      model_path 'fog/openstackcore/models/compute/v2'
      # model       :server
      # collection  :servers
      # model       :image
      # collection  :images
      # model       :flavor
      # collection  :flavors
      # model       :metadatum
      # collection  :metadata
      # model       :address
      # collection  :addresses
      # model       :security_group
      # collection  :security_groups
      # model       :security_group_rule
      # collection  :security_group_rules
      # model       :key_pair
      # collection  :key_pairs
      # model       :tenant
      # collection  :tenants
      # model       :volume
      # collection  :volumes
      # model       :network
      # collection  :networks
      # model       :snapshot
      # collection  :snapshots
      # model       :host
      # collection  :hosts

      ## REQUESTS
      #
      request_path 'fog/openstackcore/requests/compute/v2'

      # Server CRUD
      # request :list_servers
      # request :list_servers_detail
      # request :create_server
      # request :get_server_details
      # request :update_server
      # request :delete_server

      # Server Actions
      # request :server_actions
      # request :server_action
      # request :reboot_server
      # request :rebuild_server
      # request :resize_server
      # request :confirm_resize_server
      # request :revert_resize_server
      # request :pause_server
      # request :unpause_server
      # request :suspend_server
      # request :resume_server
      # request :rescue_server
      # request :change_server_password
      # request :add_fixed_ip
      # request :remove_fixed_ip
      # request :server_diagnostics
      # request :boot_from_snapshot
      # request :reset_server_state
      # request :add_security_group
      # request :remove_security_group

      # Server Extenstions
      # request :get_console_output
      # request :get_vnc_console
      # request :live_migrate_server
      # request :migrate_server

      # Image CRUD
      # request :list_images
      # request :list_images_detail
      # request :create_image
      # request :get_image_details
      # request :delete_image

      # Flavor CRUD
      # request :list_flavors
      # request :list_flavors_detail
      # request :get_flavor_details
      # request :create_flavor
      # request :delete_flavor

      # Flavor Access
      # request :add_flavor_access
      # request :remove_flavor_access
      # request :list_tenants_with_flavor_access

      # Metadata
      # request :list_metadata
      # request :get_metadata
      # request :set_metadata
      # request :update_metadata
      # request :delete_metadata

      # Metadatam
      # request :delete_meta
      # request :update_meta

      # Address
      # request :list_addresses
      # request :list_address_pools
      # request :list_all_addresses
      # request :list_private_addresses
      # request :list_public_addresses
      # request :get_address
      # request :allocate_address
      # request :associate_address
      # request :release_address
      # request :disassociate_address

      # Security Group
      # request :list_security_groups
      # request :get_security_group
      # request :create_security_group
      # request :create_security_group_rule
      # request :delete_security_group
      # request :delete_security_group_rule
      # request :get_security_group_rule

      # Key Pair
      # request :list_key_pairs
      # request :create_key_pair
      # request :delete_key_pair

      # Tenant
      # request :list_tenants
      # request :set_tenant
      # request :get_limits

      # Volume
      # request :list_volumes
      # request :create_volume
      # request :get_volume_details
      # request :delete_volume
      # request :attach_volume
      # request :detach_volume
      # request :get_server_volumes

      # request :create_volume_snapshot
      # request :list_snapshots
      # request :get_snapshot_details
      # request :delete_snapshot

      # Usage
      # request :list_usages
      # request :get_usage

      # Quota
      # request :get_quota
      # request :get_quota_defaults
      # request :update_quota

      # Hosts
      # request :list_hosts
      # request :get_host_details


      class Mock
      end

      class Real

        # attr_reader :service_catalog, :token, :auth_token, :unscoped_token,
        #             :current_tenant, :current_user

        def initialize(options={})
          @service = Fog::OpenStackCore::Identity.new(options)
        end

        def request(params)
          base_request(@service, params)
        end

        def admin_request(params)
          # create the admin service connection if necessary
          @admin_service ||= admin_connection(:keystone, @options[:openstack_region].to_sym)
          base_request(@admin_service, params)
        end

        def reload
          @service.reset
        end

      end
    end
  end
end
