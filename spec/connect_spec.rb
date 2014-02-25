require_relative './spec_helper'

require 'rubygems'
require 'fog/core'
require 'openstackcommon'

describe "connect" do
  before do

    VCR.insert_cassette('connect')

    auth_url = "http://172.16.0.2:5000/v2.0/tokens"
    # options = {
    #   :openstack_auth_uri => URI.parse(auth_url),
    #   :openstack_username => "demo",
    #   :openstack_api_key => "stack",
    #   :openstack_tenant => "invisible_to_admin",
    #   :openstack_region => "RegionOne",
    #   :openstack_service_type  => 'identity',
    #   :openstack_endpoint_type => 'publicURL'
    # }
    # connection_options = {}

    # Fog::Identity.providers = [:openstack,:openstackcommon]

    @result = Fog::Identity.new(:provider => 'OpenStackCommon',
                                :openstack_username => "demo",
                                :openstack_api_key => "stack",
                                :openstack_auth_url => auth_url,
                                :openstack_tenant => "invisible_to_admin")
  end

  it "will return a result" do
    @result.wont_be_nil
  end

  after do
    VCR.eject_cassette
  end

end