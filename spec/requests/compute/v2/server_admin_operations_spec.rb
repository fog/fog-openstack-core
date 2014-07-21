require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "server admin operations" do

      #TODO make stateful

      let(:demo_options) { demo_options_hash(false) }
      let(:service) { Fog::OpenStackCore::ComputeV2.new(demo_options) }
      let(:servers) { service.list_servers.body["servers"] }

      Minitest.after_run do
        self.after_run
      end

      def self.after_run
        VCR.use_cassette('requests/compute_v2/admin_operations/server_delete') do
          puts "cleaning up after server #{self.created_server}"
          TestContext.service.delete_server(self.created_server) if TestContext.nova_server
          TestContext.reset_context
        end
      end

      def self.created_server
        #cache the nova instance so it isnt continually being created
        TestContext.nova_server do
          #only fires once
          TestContext.service do
            Fog::OpenStackCore::ComputeV2.new(demo_options_hash)
          end
          flavors = TestContext.service.list_flavors
          images  = TestContext.service.list_images
          server  = TestContext.service.create_server("#{Time.now.to_i}server",
                                                      flavors.body["flavors"].first["id"],
                                                      images.body["images"].first["id"]).body["server"]["id"]
          #loop until ready
          begin
            tries = 7
            begin
              if self.query_active(server)
                puts "Server is UP!"
              else
                raise "Server Not Active Yet"
              end
            rescue Exception => e
              tries -= 1
              puts "Server Not Ready"
              if tries > 0
                sleep(10)
                retry
              else
                exit(1)
              end
            end
          end
          server
        end
      end

      def self.query_active(server_id)
        #return the active servers
        puts "checking active state of server #{server_id}"
        response   = TestContext.service.list_servers(:status => "ACTIVE")
        active_ids = response.body["servers"].map { |s| s["id"] }
        unless active_ids.select { |item| item == server_id }.empty?
          return true
        end
        false
      end

      let(:server) {
        self.class.created_server
      }
      it "exists", :vcr do
        refute_nil(server)
      end


      describe "and you have a server" do

        let(:flavor_id) { service.list_flavors.body['flavors'].first['id'] }
        let(:image_id) { service.list_images.body['images'].last['id'] }
        let(:create) { service.create_server(server_name, flavor_id, image_id) }


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
              @floater = @allocated.body["floating_ip"]["ip"]
              @associate = service.associate_address(server, @floater)
            end


            it "returns proper status" do
              assert_includes([202], @associate.status)
            end

            describe "#disassociate_address" do

              before do
                assert_includes(service.list_addresses(server).body["addresses"].first.to_s, @floater)
              end

              let(:remove) { service.disassociate_address(server, @floater) }

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
            name = "#{Time.now.to_i}security_group"
            @created_sg = service.create_security_group(:name => name, :description => "group for test")
            assert_includes([200], @created_sg.status)
          end

          let(:security_group) { @created_sg.body["security_group"]["name"] }
          let(:server) { servers.first["id"] }
          let(:add) { service.add_security_group(server, security_group) }


          after do
            service.remove_security_group(server, security_group)
            service.delete_security_group(@created_sg.body["security_group"]["id"])
          end

          it "returns a proper status" do
            assert_includes([202], add.status)
          end

        end

        describe '#reboot', :vcr do
          let(:reboot) { service.reboot_server(server) }

          it "returns a proper status" do
            assert_includes([202], reboot.status)
          end

        end


        describe '#rebuild', :vcr do

          let(:rebuild) { service.rebuild_server(server,{:metadata => "abcdef"}) }

          it "returns a proper status" do
            skip("wait for server details call in process")
            assert_includes([202], rebuild.status)
          end

        end

        describe '#add_security_group', :vcr do
          before do
            name = "#{Time.now.to_i}security_group"
            @created_sg = service.create_security_group(:name => name, :description => "group for test")
            assert_includes([200], @created_sg.status)
          end

          let(:security_group) { @created_sg.body["security_group"]["name"] }
          let(:add) { service.add_security_group(server, security_group) }


          after do
            service.remove_security_group(server, security_group)
            service.delete_security_group(@created_sg.body["security_group"]["id"])
          end

          it "returns a proper status" do
            assert_includes([202], add.status)
          end

        end


      end


    end
  end
end