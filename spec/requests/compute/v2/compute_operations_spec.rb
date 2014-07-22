require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2", :vcr do

    Minitest.after_run do
      self.after_run
    end

    def self.after_run
      VCR.use_cassette('requests/compute_v2server_delete') do
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
        flavors  = TestContext.service.list_flavors
        image_id = locate_bootable_image(TestContext.service)
        server   = TestContext.service.create_server("#{Time.now.to_i}server",
                                                     flavors.body["flavors"].first["id"],
                                                     image_id).body["server"]["id"]
        #loop until ready
        wait_for_server(TestContext.service, server)
        server
      end
    end

    let(:server) {
      self.class.created_server
    }

    let(:service) {
      TestContext.service
    }

    it "exists", :vcr do
      refute_nil(server)
    end

    describe "address operations" do
      describe "and a server exists" do
        describe "#list_addresses" do

          let(:addresses) { service.list_addresses(server) }

          it "returns proper status", :vcr do
            assert_includes([200, 203], addresses.status)
          end
        end
      end
    end

    describe "console operations" do
      describe "with a server" do
        describe "#get_console_output" do

          let(:console) { service.get_console_output(server) }

          it "returns proper status", :vcr do
            assert_includes([200], console.status)
          end
        end

        describe "#get_vnc_console" do
          let(:vnc) { service.get_vnc_console(server) }

          it "returns proper status", :vcr do
            assert_includes([200], vnc.status)
          end
        end
      end
    end

    describe "metadata operations" do
      describe "#show_server_metadata(server_metadata)" do

        before do
          @meta = service.show_server_metadata(server)
        end

        it "returns proper status" do
          assert_includes([200, 203], @meta.status)
        end

        it "returns proper keys" do
          refute_nil(@meta.body["metadata"])
        end

      end
      describe "#create_or_replace_server_metadata(server_metadata)" do
        let(:new_meta) {
          {
            :name => "test name"
          }
        }
        let(:meta) { service.create_or_replace_server_metadata(server, new_meta) }

        it "returns proper status" do
          assert_includes([200], meta.status)
        end

        it "returns proper keys" do
          refute_nil(meta.body["metadata"]["name"])
        end

      end
      describe "#update_server_metadata(server_metadata)" do
        let(:new_meta) {
          {
            :name => "test name"
          }
        }
        let(:newer_meta) {
          {
            :name => "updated name"
          }
        }
        let(:meta) { service.create_or_replace_server_metadata(server, new_meta) }
        let(:meta_updated) { service.update_server_metadata(server, newer_meta) }

        it "returns proper status" do
          assert_includes([200], meta.status)
        end

        it "returns proper updated value" do
          assert(meta_updated.body["metadata"]["name"] == "updated name")
        end


      end
      describe "#delete_server_metadata_for_key(server_metadata)" do
        let(:new_meta) {
          {
            :name => "test name"
          }
        }
        before do
          service.create_or_replace_server_metadata(server, new_meta)
          @meta_show = service.delete_server_metadata_for_key(server, "name")
        end


        it "returns proper status" do
          assert_includes([204], @meta_show.status)
        end

        describe "and you specify an invalid key" do
          it "throws an exception Fog::OpenStackCore::Errors::NotFound" do
            assert_raises(Fog::OpenStackCore::Errors::NotFound) {
              service.delete_server_metadata_for_key(server, "badjuju")
            }

          end
        end


      end
      describe "#show_server_metadata_for_key(server_metadata)" do
        let(:new_meta) {
          {
            :name => "test name"
          }
        }

        before do
          service.create_or_replace_server_metadata(server, new_meta)
          @meta_show = service.show_server_metadata_for_key(server, "name")
        end

        it "returns proper status" do
          assert_includes([200, 203], @meta_show.status)
        end

        it "returns proper updated value" do
          #TODO why 'meta' as the key here... sounds like a bug to me
          assert(@meta_show.body["meta"]["name"] == "test name")
        end

        describe "and you specify an invalid key" do
          it "throws an exception Fog::OpenStackCore::Errors::NotFound" do
            assert_raises(Fog::OpenStackCore::Errors::NotFound) {
              service.show_server_metadata_for_key(server, "badjuju")
            }

          end
        end

      end


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
          @floater   = @allocated.body["floating_ip"]["ip"]
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
        @dealloc    = service.deallocate_address(@allocated2.body["floating_ip"]["id"])
      end

      it "returns a proper status" do
        assert_includes([202], @dealloc.status)
      end

    end

    describe '#add_security_group' do
      before do
        name        = "#{Time.now.to_i}security_group"
        @created_sg = service.create_security_group(:name => name, :description => "group for test")
        assert_includes([200], @created_sg.status)
      end

      let(:security_group) { @created_sg.body["security_group"]["name"] }
      let(:add) { service.add_security_group(server, security_group) }


      after do
        service.remove_security_group(server, security_group)
        service.delete_security_group(@created_sg.body["security_group"]["id"])
      end

      it "returns a proper status for add" do
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
      let(:image_id) { service.list_images.body['images'].last['id'] }

      it "returns a proper status" do

        wait_for_server(service, server)

        rebuild = service.rebuild_server(server, image_id, "my-rebuilt", {:metadata => "abcdef"})

        assert_includes([202], rebuild.status)
      end

    end
  end
end