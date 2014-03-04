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
end
