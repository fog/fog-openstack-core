require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "image operations" do

      let(:demo_options) { demo_options_hash }

      let(:identity) { Fog::OpenStackCore::IdentityV2.new(demo_options) }

      let(:tenant_id) {
        data = identity.get_tenants_by_name(admin_options_hash[:openstack_tenant])
        data.body['tenant']['id']
      }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(demo_options) }

      describe "#list_images" do

        let(:list) { service.list_images }

        it "returns proper status", :vcr do
          assert_includes([200, 203], list.status)
        end

      end

      describe "#list_images?changes-since" do

        let(:list) { service.list_images("changes-since" => "2011-01-24T17:08Z") }

        it "returns proper status", :vcr do
          assert_includes([200, 203], list.status)
        end

      end

      describe "#list_images?server" do
        let(:server) { service.list_servers.body["servers"].first["id"] }

        #TODO this doesnt appear to work....
        let(:list) { service.list_images("server" => server) }

        it "returns proper status", :vcr do
          assert_includes([200, 203], list.status)
        end

      end

      describe "#list_images?name" do
        let(:server) { service.list_servers.body["servers"].first["name"] }

        #TODO this doesnt appear to work....
        let(:list) { service.list_images("server" => server) }

        it "returns proper status", :vcr do
          assert_includes([200, 203], list.status)
        end

      end

      describe "#list_images?type" do

        #TODO this doesnt appear to work....
        let(:list) { service.list_images("type" => "ALL") }

        it "returns proper status", :vcr do
          assert_includes([200, 203], list.status)
        end

      end

      describe "#list_image_details" do
        let(:image) { service.list_images.body["images"].first["id"] }

        let(:details) { service.list_image_details(image)}

        it "returns proper status", :vcr do
          assert_includes([200, 203], details.status)
        end
      end



    end
  end
end
