require_relative '../../../spec_helper'
require_relative '../../../support/spec_helpers'
include SpecHelpers

require 'fog/openstackcommon'

describe "requests" do
  describe "identity" do
    describe "v2" do
      describe "endpoint operations" do

        let(:valid_options) { admin_options_hash }

        let(:service) { Fog::Identity::V2.new(valid_options) }

        describe "#list_endpoints" do
          it { skip("Choosing to NotImplement for now.") }
        end

        describe "#add_endpoint" do
          it { skip("Choosing to NotImplement for now.") }
        end

        describe "#get_endpoint" do
          it { skip("Choosing to NotImplement for now.") }
        end

        describe "#delete_endpoint" do
          it { skip("Choosing to NotImplement for now.") }
        end

      end
    end
  end
end
