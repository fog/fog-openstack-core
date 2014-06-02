require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "security group operations" do

      let(:demo_options) { demo_options_hash(true) }

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

      describe "#get_security_group", :vcr do

        let(:security_group) { service.list_security_groups.body["security_groups"].first["id"] }
        let(:group) { service.get_security_group(security_group) }

        it "returns proper status", :vcr do
          assert_includes([200], group.status)
        end

      end

      describe "#create_security_group",:vcr do
        let (:group_name) { "#{Time.now.to_i}group"}
        let(:group) { service.create_security_group(:name => group_name,:description => "test desc") }

        after do
          service.delete_security_group(group.body["security_group"]["id"])
        end

        it "returns proper status", :vcr do
          assert_includes([200], group.status)
        end
        describe "#create_security_group_rule" do
          #
          let(:rule) { service.create_security_group_rule(group.body["security_group"]["id"], 'tcp',1,65535, "0.0.0.0/0") }
          after do
            service.delete_security_group_rule(rule.body["security_group_rule"]["id"])
          end

          it "returns proper status", :vcr do
            assert_includes([200], rule.status)
          end
        end
      end

      describe "#delete_security_group",:vcr do
        let (:group_name) { "#{Time.now.to_i}group" }
        let(:group) { service.create_security_group(:name => group_name, :description => "test desc") }
        describe "#delete_security_group_rule" do
          let(:rule) { service.create_security_group_rule(group.body["security_group"]["id"], 'tcp', 1, 65535, "0.0.0.0/0") }
          let(:delete_rule) { service.delete_security_group_rule(rule.body["security_group_rule"]["id"]) }
          it "returns proper status", :vcr do
            assert_includes([202], delete_rule.status)
         end
        end
        let(:delete) { service.delete_security_group(group.body["security_group"]["id"]) }

        it "returns proper status", :vcr do
          assert_includes([202], delete.status)
        end

      end
    end
  end
end
