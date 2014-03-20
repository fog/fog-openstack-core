require_relative '../../spec_helper'
require_relative '../../support/spec_helpers'
include SpecHelpers

require 'fog/openstackcommon'

describe "requests" do
  describe "identity" do
    describe "service operations" do

      let(:service) { Fog::Identity.new(admin_options_hash) }

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
