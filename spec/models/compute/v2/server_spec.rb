require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

def wait_for_image_to_finish_for_server(target)
  target.wait_for{ task_state != nil }
  target.wait_for { task_state != "image_snapshot" }
  target.wait_for { task_state != "image_snapshot_pending" }
  target.wait_for { task_state != "image_pending_upload" }
  target.wait_for { task_state != "image_uploading" }
end

describe "models" do
  describe "compute_v2", :vcr do

    Minitest.after_run do
      self.after_run
    end

    def self.after_run
      VCR.use_cassette('requests/compute_v2/server_delete') do
        puts "cleaning up after server #{self.created_server.id}"
        #TestContext.service.delete_server(self.created_server.id) if TestContext.nova_server
        TestContext.reset_context
      end
    end

    def self.created_server
      #cache the nova instance so it isnt continually being created
        TestContext.nova_server do
          #only fires once
          TestContext.service do
            Fog::OpenStackCore::ComputeV2.new(demo_options_hash(true))
          end
          flavors  = TestContext.service.list_flavors
          image_id = locate_bootable_image(TestContext.service)
          server   = TestContext.service.servers.create(:name => resource_name("server"),
                                                        :flavor_id => flavors.body["flavors"][1]["id"],
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

    describe "#create", :vcr do
      it "succeeds" do
        refute_nil(server)
      end
    end

    describe "#console_output(10)" do
      it "succeeds" do
        proc { server.console_output(10) }.must_output(nil,nil)
      end
    end

    describe "#vnc_console_url" do
      it "succeeds" do
          proc { server.vnc_console_url }.must_output(nil,nil)
      end
    end

    describe "#create_image('fogimgfromserver')" do
      it "succeeds" do
        proc { server.create_image('fogimgfromserver') }.must_output(nil, nil)
      end

      after do
        wait_for_image_to_finish_for_server(server)
      end
    end

    describe "#reboot('SOFT')" do
      it "succeeds" do
        proc { server.reboot }.must_output(nil, nil)
      end
      after do
        TestContext.nova_server.wait_for { TestContext.nova_server.task_state != "rebooting" }
      end
    end

    describe "security_groups" do

      before do
        @sg_name = resource_name("security_group")
        @sg = service.create_security_group({ :name => @sg_name, :description => "my test sg" }).body["security_group"]["id"]
      end

      after do
        service.delete_security_group(@sg)
      end

      describe "#add_security_group(#{@sg_name})" do
        it "succeeds" do
          proc { server.add_security_group(@sg_name) }.must_output(nil, nil)
        end
      end

      describe "#remove_security_group(#{@sg_name})" do
        it "succeeds" do
          proc { server.remove_security_group(@sg) }.must_output(nil, nil)
        end
      end
    end


  end
end
