require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "console operations" do

      let(:demo_options) { demo_options_hash }

      let(:identity) { Fog::OpenStackCore::IdentityV2.new(demo_options) }

      let(:tenant_id) {
        data = identity.get_tenants_by_name(admin_options_hash[:openstack_tenant])
        data.body['tenant']['id']
      }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(demo_options) }

      describe "#get_console_output" do

        let(:server) { service.list_servers.body["servers"].first["id"] }

        let(:console) { service.get_console_output(server) }

        it "returns proper status", :vcr do
          assert_includes([200], console.status)
        end

      end

      describe "#get_vnc_console" do

        let(:server) { service.list_servers.body["servers"].first["id"] }

        let(:console) { service.get_vnc_console(server) }

        it "returns proper status", :vcr do
          assert_includes([200], console.status)
        end

      end
    end
  end
end
