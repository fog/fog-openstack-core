require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../support/spec_helpers'

require 'fog/openstackcore'

describe "services" do
  describe "block_storage_v2" do

    describe "#initialize" do

      describe "#auth_with_credentials_and_tenant" do

        describe "with valid credentials", :vcr do

          let(:service) { Fog::OpenStackCore::BlockStorage.new(non_admin_options_hash) }

          it "returns a service reference" do
            service.must_be_instance_of Fog::OpenStackCore::BlockStorageV2::Real
          end

        end
      end
    end
  end
end
