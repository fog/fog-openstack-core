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

  describe "#list_users" do

    let(:list) { service.list_users }

    it "lists users", :vcr do
      [200, 203].must_include list.status
    end
  end

  describe "#create_user", :vcr do

    it "success" do
      name = "jsmith#{Time.now.to_i}"
      password = "password!"
      tenant_id = service.list_tenants.body['tenants'].first['id']
      email = "jsmith#{Time.now.to_i}@acme.com"
      enabled = true

      result = service.create_user(name, password, email, tenant_id, enabled)
      [200, 201].must_include result.status
    end

  end

  describe "#update_user", :vcr do

    before do
      name = "jsmith#{Time.now.to_i}"
      password = "password!"
      tenant_id = service.list_tenants.body['tenants'].first['id']
      email = "jsmith#{Time.now.to_i}@acme.com"
      enabled = true
      result = service.create_user(name, password, email, tenant_id, enabled)
      @user_id = result.body['user']['id']
    end

    describe "updateable attribs" do

      it "name" do
        result = service.update_user(@user_id, { 'name' => "bob#{Time.now.to_i}"})
        result.status.must_equal 200
      end

      it "username" do
        result = service.update_user(@user_id, { 'username' => "bob#{Time.now.to_i}"})
        result.status.must_equal 200
      end

      it "enabled" do
        result = service.update_user(@user_id, { 'enabled' => false })
        result.status.must_equal 200
      end

      it "email" do
        result = service.update_user(@user_id, { 'email' => "larry-#{Time.now.to_i}@acme.com"})
        result.status.must_equal 200
      end

    end

    describe "readonly attribs" do

      it "tenantId" do
        proc {
          service.update_user(@user_id, { 'tenantId' => "tenantId-#{Time.now.to_i}"})
        }.must_raise Fog::Identity::OpenStackCommon::NotFound
      end

      it "id" do
        proc {
          service.update_user(@user_id, { 'id' => "id-#{Time.now.to_i}"})
        }.must_raise Fog::Identity::OpenStackCommon::BadRequest
      end

    end

  end

  describe "#delete_user" do


    it { skip("TBD") }
  end

  describe "#enable_user" do
    it { skip("TBD") }
  end

  # request :list_user_global_roles         # close to :list_user_global_roles
  # describe "#list_user_global_roles" do
  #   it { skip("TBD") }
  # end

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
