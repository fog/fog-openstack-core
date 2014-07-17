require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "limits operations" do

      let(:demo_options) { demo_options_hash }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(demo_options) }

      describe "#list_limits" do

        let(:list) { service.list_limits }

        it "returns proper status", :vcr do
          assert_includes([200, 203], list.status)
        end

      end

    end
  end
end