require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "models" do
  describe "compute_v2", :vcr do

    Minitest.after_run do
      self.after_run
    end

    def self.after_run
      VCR.use_cassette('models/compute_v2server_delete') do
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
        server = TestContext.service.servers.create( :name => "#{Time.now.to_i}server",
                                                     :flavor => flavors.body["flavors"].first["id"],
                                                     :image_id => image_id)
        #loop until ready
        server.wait_for { ready? }
        server
      end
    end

    let(:server) {
      self.class.created_server
    }

    let(:service) {
      TestContext.service
    }

    it "#create", :vcr do
      refute_nil(server)
    end

    describe "#console_output(10)" do
      it "succeeds" do
         pending
      end
    end

    describe "#vnc_console_url" do
      it "succeeds" do
        pending
      end
    end

    describe "#create_image('fogimgfromserver')" do
      it "succeeds" do
        pending
      end
    end

    describe "#reboot('SOFT')" do
      it "succeeds" do
        pending
      end
    end

    describe "#add_security_group('default')" do
      it "succeeds" do
        pending
      end
    end

    describe '#remove_security_group("default")' do
      it "succeeds" do
        pending
      end
    end

  end
end
