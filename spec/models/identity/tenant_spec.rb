require_relative '../../spec_helper'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/tenant'

describe "models" do
  describe "identity" do
    describe "Fog::Identity::OpenStackCommon::Tenant" do

      let(:connect_options) { {
        :provider => 'OpenStackCommon',
        :openstack_auth_url => "http://devstack.local:5000/v2.0/tokens",
        :openstack_username => "admin",
        :openstack_api_key => "stack"
        } }
      let(:service) { Fog::Identity.new(connect_options) }

      let(:options) { {
        :service => service,
        :name => "My Tenant",
        :description => "This is my tenant for spec'ing",
        :enabled => true
        } }

      describe "#initialize", :vcr do

        before do
          @tenant = Fog::Identity::OpenStackCommon::Tenant.new(options)
        end

        describe "unsaved tenant" do

          it "is the correct type" do
            @tenant.must_be_instance_of Fog::Identity::OpenStackCommon::Tenant
          end

          it "is enabled" do
            @tenant.enabled.must_equal true
          end

          it "has correct name" do
            @tenant.name.must_equal "My Tenant"
          end

          it "has correct description" do
            @tenant.description.must_equal "This is my tenant for spec'ing"
          end

        end

      end

    end
  end
end
