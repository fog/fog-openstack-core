require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../support/spec_helpers'

require 'fog/openstackcore'
require 'fog/openstackcore/services/storage_v1'


describe "services" do
  describe "storage_v1" do

    describe "#initialize" do

      describe "#auth_with_credentials_and_tenant" do

        describe "with valid credentials", :vcr do

          let(:service) { Fog::OpenStackCore::StorageV1.new(admin_options_hash) }

          it "returns a service reference" do
            service.must_be_instance_of Fog::OpenStackCore::StorageV1::Real
          end

        end   # with valid credentials

      end  #auth_with_credentials_and_tenant

    end # initialize

  end # storage
end # services
