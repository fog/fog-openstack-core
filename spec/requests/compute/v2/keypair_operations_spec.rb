require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "keypair operations", :vcr do

      let(:demo_options) { demo_options_hash(false) }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(demo_options) }

      let(:list) { service.list_keypairs }

      describe "#list_keypairs" do
        it "should return the proper status" do
          assert_includes([200], list.status)
        end
      end

      describe "#create_keypairs" do
        let(:create) { service.create_keypair("#{Time.now().to_i}keypair") }
        it "should return the proper status" do
          assert_includes([200], list.status)
        end

        describe "#delete_keypairs" do
          let(:delete) { service.delete_keypair(create.body["keypair"]["name"]) }
          it "should return the proper status" do
            assert_includes([202], delete.status)
          end
        end

      end

      describe "#get_keypair" do
        let(:create) { service.create_keypair("#{Time.now().to_i}keypair") }
        let(:get) { service.get_keypair(create.body["keypair"]["name"]) }
        it "should return the proper status" do
          assert_includes([200], get.status)
        end

        describe "#delete_keypairs" do
          let(:delete) { service.delete_keypair(create.body["keypair"]["name"]) }
          it "should return the proper status" do
            assert_includes([202], delete.status)
          end
        end

      end




    end
  end
end
