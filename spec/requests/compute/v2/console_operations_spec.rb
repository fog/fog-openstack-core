require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "console operations" do

      let(:demo_options) {
        {
          :openstack_auth_url => ENV['OS_AUTH_URL'] || "http://devstack.local:5000",
          :openstack_username => ENV['OS_USER'] || "demo",
          :openstack_api_key  => ENV['OS_API_KEY'] || "stack",
          :openstack_tenant   => ENV['OS_TENANT'] || "demo",
          :openstack_region   => ENV['OS_REGION'] || "regionone",
          :connection_options => {:proxy => 'http://localhost:8888'}
        }
      }

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
