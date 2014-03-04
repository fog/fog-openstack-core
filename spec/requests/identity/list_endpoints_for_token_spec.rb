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

  describe "#list_endpoints_for_token", :vcr do

    before  do
    #  @result = service.list_endpoints_for_token(service.auth_token)
    end

    it "lists the endpoints" do
      skip("not sure which token to pass here")
      @result.status.must_equal 200
    end

  end
end
