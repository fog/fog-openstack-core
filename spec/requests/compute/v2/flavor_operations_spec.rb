require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "flavor operations" do

      let(:non_admin_options) { non_admin_options_hash }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(non_admin_options) }

      describe "#list_flavors" do

        let(:list) { service.list_flavors }

        it "returns proper status", :vcr do
          assert_includes([200, 203], list.status)
        end

      end

    end
  end
end
