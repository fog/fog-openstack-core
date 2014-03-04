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

    before  do
      @result = service.create_tenant( :name => "azahabada#{Time.now.to_i}", :description => "my tenant", :enabled => true)
    end

    it "creates the tenant" do
      @result.status.must_equal 200
    end

    it "returns valid data" do
      @result.body['tenant'].wont_be_nil
    end

  end
end
