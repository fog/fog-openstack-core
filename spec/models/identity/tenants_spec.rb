require_relative '../../spec_helper'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/tenants'

describe "models" do
  describe "identity" do
    describe "tenants" do

      let(:service_mock) { Minitest::Mock.new }

      let(:fake_id) { "1234567890" }

      let(:options) { {
        :service => service_mock
      } }

      let(:fake_tenants_collection) {
        Fog::Identity::OpenStackCommon::Tenants.new(options)
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


      describe "#find_by_id" do

        let(:fake_tenant_response) {
          response = OpenStruct.new
          response.body = {'tenant' => {}}
          response
        }

        it "when tenant exists in collection" do
          service_mock.expect(:list_tenants, fake_tenants_response, [])
          service_mock.expect(:get_tenant, fake_tenant_response, [fake_id])

          fake_tenants_collection.find_by_id(fake_id)
          service_mock.verify
        end

      end


      describe "#destroy" do
        it { skip("TBD") }
      end


    end
  end
end
