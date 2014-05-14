require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "security group operations" do

      let(:demo_options) { demo_options_hash }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(demo_options) }

      describe "#list_security_groups" do

        let(:list) { service.list_security_groups }

        it "returns proper status", :vcr do
          assert_includes([200], list.status)
        end

      end

      #TODO run this down, this call does not work
      #seem to recall this is a nova issue/hasnt ever worked
      #
      #describe "#list_security_groups_for_server" do
      #
      #  let(:server) { service.list_servers.body["servers"].first["id"] }
      #  let(:list) { service.list_security_groups_for_server(server) }
      #
      #  it "returns proper status", :vcr do
      #    assert_includes([200], list.status)
      #  end
      #
      #end

      describe "#get_security_group" do

        let(:security_group) { service.list_security_groups.body["security_groups"].first["id"] }
        let(:group) { service.get_security_group(security_group) }

        it "returns proper status", :vcr do
          assert_includes([200], group.status)
        end

      end

      describe "#create_security_group" do


        it "returns proper status", :vcr do
          skip("TBD")
        end

      end

      describe "#delete_security_group" do

        let(:security_group) { service.list_security_groups.body["security_groups"].first["id"] }

        it "returns proper status", :vcr do
          skip("TBD")
        end

      end



    end
  end
end
