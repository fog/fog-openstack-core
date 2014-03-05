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

  describe "#create_tenant", :vcr do

    before  do
      @result = service.create_tenant( :name => "azahabada#{Time.now.to_i}", :description => "my tenant", :enabled => true)
    end

    it "creates the tenant" do
      @result.status.must_equal 200
    end

    it "returns valid data" do
      @result.body['tenant'].wont_be_nil
    end

  end

  # request :add_role_to_user_on_tenant       # DUP -> :add_user_to_tenant
  describe "#add_role_to_user_on_tenant", :vcr do

    it "adds a role" do
      tenant_id = service.list_tenants.body['tenants'].first['id']
      user_id = service.list_users.body['users'].first['id']
      role_id = service.list_roles.body['roles'].first['id']

      result = service.add_role_to_user_on_tenant(tenant_id,user_id,role_id)
      result.status.must_equal 200
    end

  end

  # request :add_role_to_user_on_tenant       # DUP -> :add_user_to_tenant
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

  describe "#update_tenant" do
    it { skip("TBD") }
  end

  describe "#delete_tenant" do
    it { skip("TBD") }
  end

  describe "#get_tenant" do
    it { skip("TBD") }
  end

  # request :delete_user_role                 # DUP -> :remove_user_from_tenant
  describe "#delete_user_role" do
    it { skip("TBD") }
  end

end
