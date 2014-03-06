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

    describe "when it succeeds" do

      let(:result) {
        service.create_tenant(:name => "azahabada#{Time.now.to_i}")
      }

      it "creates the tenant" do
        result.status.must_equal 200
      end

      it "returns valid data" do
        result.body['tenant'].wont_be_nil
      end
    end

    describe "when it fails" do

      it "without name", :vcr do
        proc {
          service.create_tenant(:name => nil)
        }.must_raise Fog::Identity::OpenStackCommon::BadRequest
      end

      it "without name, with description", :vcr do
        proc {
          service.create_tenant(:name => nil,
                                :description => "my tenant")
        }.must_raise Fog::Identity::OpenStackCommon::BadRequest
      end

    end

  end

  describe "#add_role_to_user_on_tenant", :vcr do

    let(:role_response) { service.create_role("azahabada#{Time.now.to_i}") }

    it "adds a role" do
      tenant_id = service.list_tenants.body['tenants'].first['id']
      user_id = service.list_users.body['users'].first['id']
      role_id = role_response[:body]['role']['id']

      result = service.add_role_to_user_on_tenant(tenant_id, user_id, role_id)
      [200, 201].must_include result.status
    end

  end

  describe "#get_tenants_by_name" do
    describe "when the tenant exists" do
      it "gets the tenant", :vcr do
        tenant_name = "azahabada#{Time.now.to_i}"
        temp_tenant = service.create_tenant(tenant_name)
        result = service.get_tenants_by_name(temp_tenant.body['tenant']['name'])
        [200].must_include result.status
      end
    end

    describe "when the tenant doesnt exist" do
      it "returns not found error", :vcr do
        proc {
          service.get_tenants_by_name("nonexistenttenant12345")
        }.must_raise Fog::Identity::OpenStackCommon::NotFound
      end
    end
  end

  describe "#get_tenants_by_id" do
    describe "when the tenant exists" do
      it "gets the tenant", :vcr do
        tenant_name = "azahabada#{Time.now.to_i}"
        temp_tenant = service.create_tenant(tenant_name)
        result = service.get_tenants_by_id(temp_tenant.body['tenant']['id'])
        [200, 204].must_include result.status
      end
    end

    describe "when the tenant doesnt exist" do
      it "returns not found error", :vcr do
        proc {
          service.get_tenants_by_id("nonexistenttenant12345")
        }.must_raise Fog::Identity::OpenStackCommon::NotFound
      end
    end
  end

  describe "#update_tenant" do
    # describe "when the tenant exists" do
    #   it "gets the tenant", :vcr do
    #     tenant_name = "azahabada#{Time.now.to_i}"
    #     temp_tenant = service.create_tenant(tenant_name)
    #     result = service.get_tenants_by_id(temp_tenant.body['tenant']['id'])
    #     [200, 204].must_include result.status
    #   end
    # end
    #
    # describe "when the tenant doesnt exist" do
    #   it "returns not found error", :vcr do
    #     proc {
    #       service.get_tenants_by_id("nonexistenttenant12345")
    #     }.must_raise Fog::Identity::OpenStackCommon::NotFound
    #   end
    # end
  end

  describe "#delete_tenant" do
    it { skip("TBD") }
  end

  describe "#delete_user_role" do
    it { skip("TBD") }
  end

end
