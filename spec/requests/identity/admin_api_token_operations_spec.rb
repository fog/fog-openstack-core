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

  describe "#check_token" do

    it "good token", :vcr do
      token_id = service.auth_token
      tenant_id = service.current_tenant[:name]
      result = service.check_token(token_id, tenant_id)
      [200, 203, 204].must_include result.status
    end

    it "bad token", :vcr do
      token_id = "abcdefghijklmnopqrstuvwxyz"
      tenant_id = "dummy"
      proc {
        service.check_token(token_id, tenant_id)
      }.must_raise Fog::Identity::OpenStackCommon::NotFound
    end

  end

  describe "#validate_token" do

    it "good token", :vcr do
      token_id = service.auth_token
      tenant_id = service.current_tenant[:name]
      result = service.validate_token(token_id, tenant_id)
      [200, 203].must_include result.status
    end

    it "bad token", :vcr do
      token_id = "abcdefghijklmnopqrstuvwxyz"
      tenant_id = "dummy"
      proc {
        service.validate_token(token_id, tenant_id)
      }.must_raise Fog::Identity::OpenStackCommon::NotFound
    end

  end

  describe "#list_endpoints_for_token", :vcr do

    let(:response) { service.list_endpoints_for_token(service.auth_token) }

    it "returns a hash" do
      response.body.must_be_instance_of Hash
    end

    it "returns a valid response" do
      [200, 203].must_include response.status
    end

  end

end
