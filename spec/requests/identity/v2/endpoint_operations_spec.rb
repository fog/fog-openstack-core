require_relative '../../../spec_helper'
require_relative '../../../support/spec_helpers'
include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/identity_v2'

describe "requests" do
  describe "identity" do
    describe "v2" do
      describe "endpoint operations" do

        let(:valid_options) { admin_options_hash }

        let(:service) { Fog::OpenStackCore::IdentityV2.new(admin_options) }

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
