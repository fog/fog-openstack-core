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

    let(:result) { service.list_tenants }

    it "lists the tenants" do
      result.status.must_equal 200
    end

    it "returns valid data" do
      result.body['tenants'].first['id'].wont_be_nil
    end

  end

  describe "#get_tenants_by_name", :vcr do
    it { skip("TBD") }
  end

  describe "get_tenants_by_id", :vcr do
    it { skip("TBD") }
  end

  describe "#list_roles_for_user_on_tenant", :vcr do
    it { skip("TBD") }
  end

end
