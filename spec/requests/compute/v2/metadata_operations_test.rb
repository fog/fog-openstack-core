require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'
require 'fog/openstackcore/services/identity_v2'
describe "requests" do
  describe "compute_v2" do
    describe "metadata operations", :vcr  do

      let(:demo_options) {
        {
          :openstack_auth_url => "http://devstack.local:5000",
          :openstack_username => "demo",
          :openstack_api_key => "stack",
          :openstack_tenant  => "demo",
          :openstack_region  => "regionone" ,
          :connection_options => {:proxy => 'http://localhost:8888'}
        }

      }
     let(:identity) { Fog::OpenStackCore::IdentityV2.new(demo_options) }

      let(:tenant_id) {
        data = identity.current_tenant
        data['id']
      }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(demo_options) }

      let(:server) { service.list_servers(tenant_id).body["servers"].first["id"] }

      describe "#show_server_metadata"  do
        let(:meta) { service.show_server_metadata(tenant_id,server) }

        it "returns proper status"  do
          assert_includes([200, 203], meta.status)
        end

        it "returns proper keys" do
          refute_nil(meta.body["metadata"])
        end

      end

      describe "#create_or_replace_server_metadata" do
        let(:new_meta) {
          {
            :name => "test name"
          }
        }
        let(:meta) { service.create_or_replace_server_metadata(tenant_id, server, new_meta) }

        it "returns proper status" do
          assert_includes([200], meta.status)
        end

        it "returns proper keys" do
          refute_nil(meta.body["metadata"]["name"])
        end

      end

      describe "#update_server_metadata" do
        let(:new_meta) {
          {
            :name => "test name"
          }
        }
        let(:new_meta) {
          {
            :name => "updated name"
          }
        }
        let(:meta) { service.create_or_replace_server_metadata(tenant_id, server, new_meta) }
        let(:meta_updated) { service.update_server_metadata(tenant_id, server, new_meta) }

        it "returns proper status" do
          assert_includes([200], meta.status)
        end

        it "returns proper updated value" do
          assert(meta_updated.body["metadata"]["name"] == "updated name")
        end

      end

      describe "#delete_server_metadata_for_key" do
        let(:new_meta) {
          {
            :name => "test name"
          }
        }
        before do
          service.create_or_replace_server_metadata(tenant_id, server, new_meta)
          @meta_show = service.delete_server_metadata_for_key(tenant_id, server, "name")
        end


        it "returns proper status" do
          assert_includes([204], @meta_show.status)
        end


      end
      describe "#show_server_metadata_for_key" do
        let(:new_meta) {
          {
            :name => "test name"
          }
        }

        before do
          service.create_or_replace_server_metadata(tenant_id, server, new_meta)
          @meta_show = service.show_server_metadata_for_key(tenant_id, server, "name")
        end

        it "returns proper status" do
          assert_includes([200, 203], @meta_show.status)
        end

        it "returns proper updated value" do
          #TODO why 'meta' as the key here... sounds like a bug to me
          assert(@meta_show.body["meta"]["name"] == "test name")
        end

      end

    end
  end
end
