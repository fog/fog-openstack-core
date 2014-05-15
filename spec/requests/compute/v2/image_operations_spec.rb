require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "image operations" do

      let(:admin_options) { admin_options_hash }

      let(:identity) { Fog::OpenStackCore::IdentityV2.new(admin_options) }

      let(:tenant_id) {
        data = identity.get_tenants_by_name(admin_options_hash[:openstack_tenant])
        data.body['tenant']['id']
      }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(admin_options) }

      describe "#list_images" do

        let(:list) { service.list_images }

        it "returns proper status", :vcr do
          assert_includes([200, 203], list.status)
        end

      end

    end
  end
end
