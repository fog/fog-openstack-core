require_relative '../spec_helper'
require_relative '../support/spec_helpers'
include SpecHelpers

require 'fog/openstackcommon'

describe "services" do
  describe "identity" do
    describe "v1" do

      let(:admin_options) { admin_options_hash }

      describe "#initialize" do

        describe "endpoint v1" do
          describe "auth with credentails" do
            it { skip("TBD") }
          end
        end

      end # initialize

    end # v1
  end # identity
end # services
