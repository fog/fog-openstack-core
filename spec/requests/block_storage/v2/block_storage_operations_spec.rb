require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/block_storage_v2'

describe "requests" do
  describe "block_storage_v2", :vcr do

    let(:demo_options) { demo_options_hash}

    let(:service) { Fog::OpenStackCore::BlockStorageV2.new(demo_options) }


    describe "#list_volumes" do
      let(:list) { service.list_volumes }

      it "returns proper status", :vcr do
        assert_includes([200], list.status)
      end

    end

    describe "details" do


      describe "#list_volumes_detail" do
        it "returns proper status", :vcr do
          details = service.list_volumes_detail
          assert_includes([200], details.status)
        end
      end

      describe "#get_volume_details" do
        let(:volname) { "#{Time.now().to_i}volume" }
        before do
          @vol = service.create_volume(:display_name => volname, :size => 1).body["volume"]["id"]
          wait_for_volume(service, @vol)
        end

        after do
          service.delete_volume(@vol)
        end

        let(:request) { service.get_volume_details(@vol) }

        it "returns proper status", :vcr do
          assert_includes([200], request.status)
        end
      end

    end





  end
end