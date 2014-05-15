require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "server admin operations" do

      let(:demo_options) { demo_options_hash(true) }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(demo_options) }

      let(:servers) { service.list_servers.body["servers"]}

      it "needs a server",:vcr do
        refute_empty(servers)
      end

      describe '#allocate_floating_ips', :vcr do
        before do
          @allocated = service.allocate_address
        end

        it "returns a proper status" do
          assert_includes([200], @allocated.status)
        end

        describe "#list_floating_ips", :vcr do
          before do
            @ips = service.list_floating_ips
          end


          it "returns proper status" do
            assert_includes([200], @ips.status)
          end

          it "is not empty" do
            refute_empty(@ips.body["floating_ips"], "floating ip collection is empty")
          end


        end

        describe "#associate_address", :vcr do
          #needs a server and an address
          before do
            @server = servers.first["id"]
            @floater = @allocated.body["floating_ip"]["ip"]
            @associate = service.associate_address(@server, @floater)
          end



          it "returns proper status" do
            assert_includes([202], @associate.status)
          end

          describe "#disassociate_address" do

            before do
              assert_includes(service.list_addresses(@server).body["addresses"].first.to_s, @floater)
            end

            let(:remove) { service.disassociate_address(@server, @floater) }

            it "returns proper status" do
              assert_includes([202], remove.status)
            end

          end


        end

        after do
          service.deallocate_address(@allocated.body["floating_ip"]["id"])
        end
      end

      describe '#deallocate_floating_ips', :vcr do
        before do
          @allocated2 = service.allocate_address
          @dealloc = service.deallocate_address(@allocated2.body["floating_ip"]["id"])
        end

        it "returns a proper status" do
          assert_includes([202], @dealloc.status)
        end

      end

      describe '#add_security_group', :vcr do
        before do
          @allocated_sg = service.add_security_group("mine")
        end


      end





    end
  end
end
