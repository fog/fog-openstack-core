require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../../../support/spec_helpers'

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "server operations" do

      let(:admin_options) { admin_options_hash }
      let(:service) { Fog::OpenStackCore::ComputeV2.new(admin_options) }
      let(:tenant_name) { admin_options['openstack_tenant'] }

      describe "#list_servers" do

        let(:list) { service.list_servers(tenant_name) }

        # it "returns proper status", :vcr do
        #   assert_includes([200, 203], list.status)
        # end

        it "returns proper status", :vcr do
          assert_includes([404], list.status)
        end

      end

    end
  end
end
