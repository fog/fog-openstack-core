require_relative './spec_helper'
require_relative './support/spec_helpers'
include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/identity_session'

describe "identity_session" do

  let(:service_mock) { Minitest::Mock.new }

  describe "#initialize" do
    describe "with tenant" do 

      let(:admin_options) { admin_options_hash }
      let(:service) { Fog::OpenStackCore::IdentityV2.new(admin_options) }
      let(:identity_session) { service.identity_session }

      it "sets service catalog", :vcr do
        refute_nil identity_session.service_catalog
      end

      it "sets current tenant", :vcr do
        refute_nil identity_session.current_tenant
      end

      it "sets current user", :vcr do
        refute_nil identity_session.current_user
      end

      it "sets token", :vcr do
        refute_nil identity_session.token
      end

      it "sets auth_token", :vcr do
        refute_nil identity_session.auth_token
      end
      
      it "sets nil unscoped_token", :vcr do
        assert_nil identity_session.unscoped_token
      end

    end

    describe "without tenant" do 

      let(:non_tenant_options) { non_tenant_options_hash }
      let(:service) { Fog::OpenStackCore::IdentityV2.new(non_tenant_options) }
      let(:identity_session) { service.identity_session }

      it "sets nil service catalog", :vcr do
        assert_nil identity_session.service_catalog
      end

      it "sets nil current tenant", :vcr do
        assert_nil identity_session.current_tenant
      end

      it "sets current user", :vcr do
        refute_nil identity_session.current_user
      end

      it "sets token", :vcr do
        refute_nil identity_session.token
      end

      it "sets unscoped_token", :vcr do
        refute_nil identity_session.unscoped_token
      end

      it "sets auth_token = unscoped_token", :vcr do
        assert_equal identity_session.auth_token, identity_session.unscoped_token
      end

    end
  end # initialize
end