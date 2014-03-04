require_relative '../../spec_helper'

require 'fog/openstackcommon'

describe Fog::Identity::OpenStackCommon::Real do

  let(:valid_options) { {
    :provider          => 'OpenStackCommon',
    :openstack_auth_url => "http://devstack.local:5000/v2.0/tokens",
    :openstack_username => "admin",
    :openstack_api_key => "stack"
  } }

  let(:service) { Fog::Identity.new(valid_options) }

  describe "#add_role_to_user_on_tenant", :vcr do

    it "adds a role" do
      tenant_id = service.list_tenants.body['tenants'].first['id']
      user_id = service.list_users.body['users'].first['id']
      role_id = service.list_roles.body['roles'].first['id']

      result = service.add_role_to_user_on_tenant(tenant_id,user_id,role_id)
      result.status.must_equal 200
    end

  end
end
