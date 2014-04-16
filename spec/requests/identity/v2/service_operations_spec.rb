require_relative '../../../spec_helper'
require_relative '../../../support/spec_helpers'
include SpecHelpers

require 'fog/openstackcore'

describe "requests" do
  describe "identity" do
    describe "v2" do
      describe "service operations" do

        let(:admin_options) { admin_options_hash }

        let(:service) {
          Fog::OpenStackCore::IdentityV2.new(admin_options)
        }

        describe "#list_services" do
          it { skip("Choosing to NotImplement for now.") }
        end

        describe "#add_service" do
          it { skip("Choosing to NotImplement for now.") }
        end

        describe "#get_service" do
          it { skip("Choosing to NotImplement for now.") }
        end

        describe "#delete_service" do
          it { skip("Choosing to NotImplement for now.") }
        end

      end
    end
  end
end
