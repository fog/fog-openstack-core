require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "server operations" do

      let(:admin_options) { admin_options_hash }
      let(:identity) { Fog::OpenStackCore::IdentityV2.new(admin_options) }

      let(:tenant_id) {
        data = identity.get_tenants_by_name(admin_options_hash[:openstack_tenant])
        data.body['tenant']['id']
      }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(admin_options) }

      describe "#list_servers" do

        let(:list) { service.list_servers }

        it "returns proper status", :vcr do
          assert_includes([200, 203], list.status)
        end

      end

    end
  end
end
