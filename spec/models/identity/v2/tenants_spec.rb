require_relative '../../../spec_helper'

require 'fog/openstackcore'
require 'fog/openstackcore/models/identity/v2/tenants'

require 'ostruct'

describe "models" do
  describe "identity_v2" do
    describe "tenants" do

      let(:service_mock) { Minitest::Mock.new }

      let(:fake_id) { "1234567890" }

      let(:options) {
        { :service => service_mock }
      }

      let(:fake_tenants_collection) {
        Fog::OpenStackCore::IdentityV2::Tenants.new(options)
      }

      let(:fake_tenants_response) {
        response = OpenStruct.new
        response.body = {'tenants' => {}}
        response
      }


      describe "#all" do

        it "gets all users" do
          service_mock.expect(:list_tenants, fake_tenants_response, [])

          fake_tenants_collection.all
          service_mock.verify
        end

      end


      describe "#destroy" do
        it { skip("TBD") }
      end


    end
  end
end
