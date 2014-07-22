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

      let(:service) { Fog::OpenStackCore::ComputeV2.new(demo_options) }

      Minitest.after_run do
        self.after_run
      end

      def self.after_run
        VCR.use_cassette('requests/compute_v2/console_operations/server_delete') do
          puts "cleaning up after server #{self.created_server}"
          TestContext.service.delete_server(self.created_server) if TestContext.nova_server
          TestContext.reset_context
        end
      end

      def self.created_server
        #cache the nova instance so it isnt continually being created
        TestContext.nova_server do
          #only fires once
          TestContext.service do
            Fog::OpenStackCore::ComputeV2.new(demo_options_hash)
          end
          flavors = TestContext.service.list_flavors
          image_id = locate_bootable_image(TestContext.service)
          server   = TestContext.service.create_server("#{Time.now.to_i}server",
                                                       flavors.body["flavors"].first["id"],
                                                       image_id).body["server"]["id"]
          wait_for_server(TestContext.service, server)
          server
        end
      end

      let(:server) {
        self.class.created_server
      }
      it "exists", :vcr do
        refute_nil(server)
      end

      describe "with a server" do

        describe "#get_console_output" do
          let(:console) { service.get_console_output(server) }
          it "returns proper status", :vcr do
              assert_includes([200], console.status)
          end
        end

        describe "#get_vnc_console" do
          let(:vnc) { service.get_vnc_console(server) }
          it "returns proper status", :vcr do
              assert_includes([200], vnc.status)
          end
        end
      end
    end
  end
end
