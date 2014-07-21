require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "address operations" do
      let(:demo_options) { demo_options_hash }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(demo_options) }
      let(:image) {service.list_images.body["images"].first["id"]}
      let(:flavor) { service.list_flavors.body["flavors"].first["id"] }

      Minitest.after_run do
        self.after_run
      end

      def self.after_run
        VCR.use_cassette('requests/compute_v2/addresses_operations/server_delete') do
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
      it "exists",:vcr do
        refute_nil(server)
      end

      describe "and a server exists" do

        describe "#list_addresses" do


          let(:addresses) { service.list_addresses(server) }

          it "returns proper status", :vcr do
            assert_includes([200, 203], addresses.status)
          end

        end


     end


    end
  end
end