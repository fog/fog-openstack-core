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

  let(:response) { service.list_endpoints_for_token(service.auth_token) }

  describe "#list_endpoints_for_token", :vcr do

    it "returns a hash" do
      response.body.must_be_instance_of Hash
    end

    it "returns a valid response" do
      [200, 203].must_include response.status
    end

  end
end
