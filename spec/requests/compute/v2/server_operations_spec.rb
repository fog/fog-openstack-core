require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "server operations" do

      let(:admin_options) { admin_options_hash }
      let(:identity) { Fog::OpenStackCore::IdentityV2.new(admin_options) }

      let(:tenant_id) {
        data = identity.get_tenants_by_name(admin_options_hash[:openstack_tenant])
        data.body['tenant']['id']
      }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(admin_options) }

      describe "#list_servers" do

        let(:list) { service.list_servers(tenant_id) }

        it "returns proper status", :vcr do
          assert_includes([200, 203], list.status)
        end

      end

      describe "#create_server" do
        let(:params) {
          :name => "test-server",
          :server => "test-server",
          :imageRef => "87150bf9-fada-4a1d-873a-51d4980161ce",
          :flavorRef => 42
        }
        result = service.create_server(:params)
        assert_equal (result.status, 202)
      end

    end
  end
end
