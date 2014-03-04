require_relative '../../spec_helper'
require_relative '../../devstack'

require 'fog/openstackcommon'

describe Fog::Identity::OpenStackCommon::Real do

  let(:valid_options) { {
    :provider          => 'OpenStackCommon',
    :openstack_auth_url => "http://#{IP_ADDRESS}:5000/v2.0/tokens",
    :openstack_username => "admin",
    :openstack_api_key => "stack"
  } }

  let(:service) { Fog::Identity.new(valid_options) }

  describe "#list_tenants", :vcr do

    before  do
      @result = service.list_tenants
    end

    it "lists the tenants" do
      @result.status.must_equal 200
    end

    it "returns valid data" do
      @result.body['tenants'].first['id'].wont_be_nil
    end

  end
end
