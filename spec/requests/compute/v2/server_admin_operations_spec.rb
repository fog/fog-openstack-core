require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "server admin operations" do

      let(:demo_options) { demo_options_hash }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(demo_options) }

      describe '#allocate_floating_ips', :vcr do
        let(:allocated) {service.allocate_address}

        it "returns a proper status" do
          assert_includes([200], allocated.status)
        end

        describe "#list_floating_ips", :vcr do

          let(:list) { service.list_floating_ips }

          it "returns proper status" do
            assert_includes([200], list.status)
          end

        end

        describe "#associate_address" do
          #needs a server and an address
          let(:server) { service.list_servers.body["servers"].first["id"] }
          let(:floater) { allocated.body["floating_ip"]["ip"] }
          let(:list) { service.associate_address(server,floater) }

          it "returns proper status" do
            assert_includes([202], list.status)
          end

          describe "#disassociate_address" do

            before do
              assert_includes(service.)
            end

            let(:remove) { service.disassociate_address(server, floater) }

            it "returns proper status" do
              assert_includes([200], remove.status)
            end

          end


        end

        after do
          service.deallocate_address(allocated.body["floating_ip"]["id"])
        end
      end




    end
  end
end
