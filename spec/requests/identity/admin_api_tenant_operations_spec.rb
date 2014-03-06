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

  describe "#list_tenants", :vcr do

  #         'tenants_links' => [],
  #         'tenants' => [
  #           {'id' => '1',
  #            'description' => 'Has access to everything',
  #            'enabled' => true,
  #            'name' => 'admin'},
  #           {'id' => '2',
  #            'description' => 'Normal tenant',
  #            'enabled' => true,
  #            'name' => 'default'},
  #           {'id' => '3',
  #            'description' => 'Disabled tenant',
  #            'enabled' => false,
  #            'name' => 'disabled'}
  #         ]
  #       },
  #       :status => [200, 204][rand(1)]

    let(:list) { service.list_tenants }

    it "lists the tenants" do
      [200, 204].must_include list.status
    end

    it "returns valid data" do
      list.body['tenants'].first['id'].wont_be_nil
    end

  end

  describe "#get_tenants_by_name" do

    let(:list) { service.list_tenants }

    it "gets tenant", :vcr do
      name = list.body['tenants'].first['name']
      test_tenant = service.get_tenants_by_name(name)
      [200, 204].must_include list.status
    end

    it "returns not found error", :vcr do
      proc {
        service.get_tenants_by_name("missingtenant12345")
      }.must_raise Fog::Identity::OpenStackCommon::NotFound
    end

  end

  describe "#get_tenants_by_id" do

    let(:list) { service.list_tenants }

    it "gets tenant", :vcr do
      id = list.body['tenants'].first['id']
      test_tenant = service.get_tenants_by_id(id)
      [200, 204].must_include list.status
    end

    it "returns not found error", :vcr do
      proc {
        service.get_tenants_by_id("123456789")
      }.must_raise Fog::Identity::OpenStackCommon::NotFound
    end

    #     response.status = [200, 204][rand(1)]
    #     response.body = {
    #       'tenant' => {
    #         'id' => id,
    #         'description' => 'Has access to everything',
    #         'enabled' => true,
    #         'name' => 'admin' } }
  end

  describe "#list_roles_for_user_on_tenant", :vcr do

    let(:list) { service.list_tenants }

    it "gets list of roles", :vcr do
      tenant_id = list.body['tenants'].first['id']
      user_id = "2f649419c1ed4801bea38ead0e1ed6ad"
      result = service.list_roles_for_user_on_tenant(tenant_id, user_id)
      [200, 204].must_include result.status
    end

    #       :body   => { 'roles' => roles },
    #       :status => 200
  end

end
