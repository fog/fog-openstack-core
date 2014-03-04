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

  describe "#add_user_to_tenant", :vcr do

    it "adds a user" do
      name     = "jsmith#{Time.now.to_i}"
      password = "password!"
      tenant_id = service.list_tenants.body['tenants'].first['id']
      email    = "jsmith#{Time.now.to_i}@acme.com"
      enabled  = true

      result = service.create_user(name, password, email, tenant_id, enabled)
      tenant = service.list_tenants
      puts tenant

    end

  end
end
