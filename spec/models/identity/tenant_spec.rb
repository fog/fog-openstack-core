require_relative '../../spec_helper'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/tenant'

describe "models" do
  describe "identity" do
    describe "tenant" do

      let(:connect_options) { {
        :provider => 'OpenStackCommon',
        :openstack_auth_url => "http://devstack.local:5000/v2.0/tokens",
        :openstack_username => "admin",
        :openstack_api_key => "stack"
        } }
      let(:service) { Fog::Identity.new(connect_options) }

      let(:options) { {
        :service => service,
        :name => "MyTenant-#{Time.now.to_i}",
        :description => "MyTenantDescription",
        :enabled => true
        } }

      describe "new tenant" do

        let(:unsaved_tenant) {
          Fog::Identity::OpenStackCommon::Tenant.new(options)
        }

        # describe "#initialize", :vcr do
        #
        #   describe "unsaved tenant" do
        #
        #     it "is the correct type" do
        #       unsaved_tenant.must_be_instance_of Fog::Identity::OpenStackCommon::Tenant
        #     end
        #
        #     it "is enabled" do
        #       unsaved_tenant.enabled.must_equal true
        #     end
        #
        #     it "has correct name" do
        #       unsaved_tenant.name.must_equal "MyTenant"
        #     end
        #
        #     it "has correct description" do
        #       unsaved_tenant.description.must_equal "My tenant description"
        #     end
        #
        #   end
        #
        # end

        describe "#save", :vcr do

          it "creates a new tenant" do
            result = unsaved_tenant.save
            result.must_be_instance_of Fog::Identity::OpenStackCommon::Tenant
          end

          # it "updates an existing tenant" do
          #   unsaved_tenant.save
          #   result = unsaved_tenant.save
          #   result.must_equal true
          # end

        end

      end

      # describe "existing tenant" do

        # let(:saved_tenant) {
        #   tenant = Fog::Identity::OpenStackCommon::Tenant.new(options)
        #   saved_tenant = tenant.save
        #   saved_tenant
        # }
        #
        # describe "#save" do
        # end

        # describe "#create" do
        # end

        # describe "#update" do
        # end

        # describe "#destroy", :vcr do
        #
        #   it "returns true when tenant exists" do
        #     result = saved_tenant.destroy
        #     result.must_equal true
        #   end
        #
        #   it "throw exception when invalid tenant" do
        #     proc {
        #       tenant = Fog::Identity::OpenStackCommon::Tenant.new(options)
        #       tenant.destroy
        #     }.must_raise Fog::Identity::OpenStackCommon::NotFound
        #   end
        #
        # end
        #
        #
        # describe "#to_s" do
        # end
        #
        # describe "#roles_for" do
        # end
        #
        # describe "#users" do
        # end
        #
        # describe "#grant_user_role" do
        # end
        #
        # describe "#revoke_user_role" do
        # end

      # end




    end
  end
end
