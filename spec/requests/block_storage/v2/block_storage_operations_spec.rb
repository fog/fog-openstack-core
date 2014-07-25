require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/block_storage_v2'

describe "requests" do
  describe "block_storage_v2", :vcr do

    let(:demo_options) { demo_options_hash(true) }

    let(:service) { Fog::OpenStackCore::BlockStorageV2.new(demo_options) }


    describe "#list_volumes" do
      let(:list) { service.list_volumes }

      it "returns proper status", :vcr do
        assert_includes([200], list.status)
      end

    end

    describe "#list_volumes_detail" do
      let(:volname) { "#{Time.now().to_i}volume" }
      before do
        @vol = service.create_volume(:display_name => volname, :size => 1).body["volume"]["id"]
      end
      after do
        service.delete_volume(@vol)
      end
      it "returns proper status", :vcr do
        details = service.list_volumes_detail(@vol)
        assert_includes([200], details.status)
      end
    end
  end
end