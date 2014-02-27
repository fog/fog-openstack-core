require_relative './spec_helper'

# require 'rubygems'
# require 'fog/core'
require 'fog/openstackcommon'

describe Fog::Identity::OpenStackCommon::Real do
  describe "#initialize" do
    let(:connection) {
      Fog::Identity.new(
        :provider => 'OpenStackCommon',
        :openstack_auth_url => "http://172.16.0.2:5000/v2.0/tokens",
        :openstack_username => "demo",
        :openstack_api_key => "stack",
        :openstack_tenant => "invisible_to_admin")
    }

    before do
      VCR.insert_cassette 'connection', :record => :new_episodes
    end

    after do
      VCR.eject_cassette
    end

    it "must not be nil" do
      connection.wont_be_nil
    end

    it "must have a current_user method" do
      connection.must_respond_to :current_user
    end

    it "must have a current_tenant method" do
      connection.must_respond_to :current_tenant
    end

    it "must have an unscoped_token" do
      connection.must_respond_to :unscoped_token
    end

    it "must have an connection_options" do
      connection.must_respond_to :connection_options
    end


  end

  describe "#credentials" do

  end

  describe "#reload" do

  end

  describe "#request" do

  end

end