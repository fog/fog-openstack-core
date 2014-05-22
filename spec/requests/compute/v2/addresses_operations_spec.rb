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
      #assumes there is a server in your ds instance
      let(:server) { service.list_servers.body["servers"].first["id"] }

      describe "#list_addresses" do

        let(:addresses) { service.list_addresses(server) }

        it "returns proper status", :vcr do
          assert_includes([200, 203], addresses.status)
        end

      end

      describe "#list_addresses_by_network" do

        let(:networks) { service.list_networks}

        let(:network_label) {networks.body["networks"].first["label"]}

        let(:addresses) { service.list_addresses_by_network(server, network_label) }

        it "returns proper status", :vcr do
          assert_includes([200, 203], addresses.status)
        end

      end



    end
  end
end