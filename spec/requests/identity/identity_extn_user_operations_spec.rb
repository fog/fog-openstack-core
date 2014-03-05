require_relative '../../spec_helper'
require 'fog/openstackcommon'

describe Fog::Identity::OpenStackCommon::Real do

  let(:valid_options) { {
    :provider => 'OpenStackCommon',
    :openstack_auth_url => "http://devstack.local:5000/v2.0/tokens",
    :openstack_username => "admin",
    :openstack_api_key => "stack"
    } }

  let(:service) { Fog::Identity.new(valid_options) }

  describe "#create_user", :vcr do

    it "creates a user" do
      name = "jsmith#{Time.now.to_i}"
      password = "password!"
      tenant_id = service.list_tenants.body['tenants'].first['id']
      email = "jsmith#{Time.now.to_i}@acme.com"
      enabled = true

      result = service.create_user(name, password, email, tenant_id, enabled)
      result.status.must_equal 200
    end

  end


  # request :list_users                       # missing limits
  describe "#list_users" do
    it { skip("TBD") }
  end

  describe "#create_user" do
    it { skip("TBD") }
  end

  describe "#update_user" do
    it { skip("TBD") }
  end

  describe "#delete_user" do
    it { skip("TBD") }
  end

  describe "#enable_user" do
    it { skip("TBD") }
  end

  # request :list_user_global_roles         # close to :list_user_global_roles
  describe "#list_user_global_roles" do
    it { skip("TBD") }
  end

  describe "#add_global_role_to_user" do
    it { skip("TBD") }
  end

  describe "#delete_global_role_from_user" do
    it { skip("TBD") }
  end

  describe "#add_user_credentials" do
    it { skip("TBD") }
  end

  describe "#list_credentials" do
    it { skip("TBD") }
  end

  describe "#update_user_credentials" do
    it { skip("TBD") }
  end

  describe "#delete_user_credentials" do
    it { skip("TBD") }
  end

  describe "#get_user_credentials" do
    it { skip("TBD") }
  end

end
