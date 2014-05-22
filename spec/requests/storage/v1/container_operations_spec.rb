require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/storage_v1'

describe "requests" do
  describe "storage_v1" do
    describe "container operations" do

      let(:admin_options) { admin_options_hash }

      let(:identity) { Fog::OpenStackCore::IdentityV2.new(admin_options) }

      let(:tenant_id) {
        data = identity.get_tenants_by_name(admin_options_hash[:openstack_tenant])
        data.body['tenant']['id']
      }
      let(:service) { Fog::OpenStackCore::StorageV1.new(admin_options) }

      describe "#get_containers" do

        let(:response) { service.get_containers }

        it "returns proper status", :vcr do
          assert_includes([200, 204], response.status)
        end

      end
      
      describe "#head_containers" do
        
        let(:response) { service.head_containers }
        
        it "returns the proper status", :vcr do
          assert_includes([204], response.status)
        end
        
      end

    end
  end
end
