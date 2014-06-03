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

      describe "with a server" do
        before do
          flavor = service.list_flavors.body["flavors"].first["id"]
          image = service.list_images.body["images"].first["id"]
          name = "{Time.now.to_i}server"
          @create = service.create_server(name,flavor,image).body["server"]["id"]
        end

        after do
         service.delete_server(@create)
        end


        describe "#get_console_output" do

          let(:server) { @create }

          it "returns proper status", :vcr do
            assert_raises(Fog::OpenStackCore::Conflict, "Server was ready" ) do
              service.get_console_output(server)
            end
          end

        end

        describe "#get_vnc_console" do

          let(:server) { @create }

          it "returns proper status", :vcr do
            assert_raises(Fog::OpenStackCore::Conflict, "Server was ready") do
              service.get_vnc_console(server)
            end
          end

        end
      end


    end
  end
end
