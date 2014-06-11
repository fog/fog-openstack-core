require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'
require 'fog/openstackcore/services/identity_v2'


describe "requests" do
  describe "compute_v2" do
    describe "metadata operations", :vcr do
      let(:service){ compute_v2_service(true) }

      Minitest.after_run do
        self.after_run
      end

      def self.after_run
        VCR.use_cassette('delete') do
          compute_v2_service.delete_server($created_server) if $created_server
        end
      end


      def self.created_server
        $created_server ||= begin
                              #only fires once

          flavors  = compute_v2_service.list_flavors
          images   = compute_v2_service.list_images
          server   = compute_v2_service.create_server("#{Time.now.to_i}server", flavors.body["flavors"].first["id"], images.body["images"].first["id"]).body["server"]["id"]
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
        response   = compute_v2_service.list_servers(:status => "ACTIVE")
        active_ids = response.body["servers"].map { |s| s["id"] }
        unless active_ids.select { |item| item == server_id }.empty?
          return true
        end
        false
      end

      let(:server) {
        self.class.created_server
      }
      it "exists" do
        refute_nil(server)
      end

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

  end
end
