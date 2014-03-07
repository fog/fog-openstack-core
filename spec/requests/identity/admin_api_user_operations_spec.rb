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

  describe "#get_user_by_name" do

    it "gets user", :vcr do
      user_list = service.list_users
      valid_user_name = user_list.body['users'].first["username"]
      result = service.get_user_by_name(valid_user_name)
      result.status.must_equal 200
    end

    it "returns not found error", :vcr do
      proc {
        service.get_user_by_name("nonexistentuser12345")
      }.must_raise Fog::Identity::OpenStackCommon::NotFound
    end

  end

  describe "#get_user_by_id" do

    it "gets user", :vcr do
      valid_user_id = service.list_users.body['users'].first["id"]
      result = service.get_user_by_id(valid_user_id)
      result.status.must_equal 200
    end

    it "returns not found error", :vcr do
      proc {
        service.get_user_by_id("nonexistentuser12345")
      }.must_raise Fog::Identity::OpenStackCommon::NotFound
    end

  end

  describe "#list_user_global_roles" do
    it { skip("API returns NotImplemented") }
  end

end
