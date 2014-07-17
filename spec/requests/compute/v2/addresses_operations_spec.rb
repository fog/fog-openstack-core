require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "address operations" do
      let(:demo_options) { demo_options_hash }

      let(:identity) { Fog::OpenStackCore::IdentityV2.new(demo_options) }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(demo_options) }
      let(:image) {service.list_images.body["images"].first["id"]}
      let(:flavor) { service.list_flavors.body["flavors"].first["id"] }

      describe "and a server exists" do



        describe "#list_addresses" do
          before do
            name     =" #{Time.now.to_i}server"
            @created = service.create_server(name, flavor, image).body["server"]["id"]
          end

          after do
            service.delete_server(@created)
          end

          let(:addresses) { service.list_addresses(@created) }

          it "returns proper status", :vcr do
            assert_includes([200, 203], addresses.status)
          end

        end


     end


    end
  end
end