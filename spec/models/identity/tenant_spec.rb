require_relative '../../spec_helper'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/tenant'

describe "models" do
  describe "identity" do
    describe "tenant" do

      let(:service_mock) { Minitest::Mock.new }

      let(:fake_id) { "tenant123" }
      let(:fake_name) { "MyTenant-#{Time.now.to_i}" }
      let(:fake_description) { "MyTenantDescription" }
      let(:fake_enabled) { true }

      let(:options) { {
        :service => service_mock,
        :name => fake_name,
        :description => fake_description,
        :enabled => fake_enabled
        } }

      let(:fake_tenant_response) {
        response = OpenStruct.new
        response.body = {'tenant' => {}}
        response
      }

      before do
        # have to do this to handle fog-core check
        service_mock.expect(:nil?, false, [])
      end

      describe "#initialize" do

        it "throws exception when name is missing" do
          proc {
            options.delete(:name)
            new_tenant = Fog::Identity::OpenStackCommon::Tenant.new(options)
            options.delete(:service)
            service_mock.expect(:create_tenant, fake_tenant_response, [options])

            new_tenant.save
            service_mock.verify
          }.must_raise ArgumentError
        end

        it "creates tenant when name is specified" do
          new_tenant = Fog::Identity::OpenStackCommon::Tenant.new(options)
          options.delete(:service)
          service_mock.expect(:create_tenant, fake_tenant_response, [options])

          new_tenant.save
          service_mock.verify
        end

      end

      describe "#update" do

        let(:fake_tenant) {
          Fog::Identity::OpenStackCommon::Tenant.new(options.merge!('id' => fake_id))
        }

        it "updates name" do
          new_name = { 'name' => 'new-name' }
          service_mock.expect(:update_tenant, fake_tenant_response, [fake_tenant.id, new_name])

          fake_tenant.update(new_name)
          service_mock.verify
        end

        it "updates description" do
          new_description = { 'description' => 'test123' }
          service_mock.expect(:update_tenant, fake_tenant_response, [fake_tenant.id, new_description])

          fake_tenant.update(new_description)
          service_mock.verify
        end

        it "updates enabled" do
          new_enabled = { 'enabled' => false }
          service_mock.expect(:update_tenant, fake_tenant_response, [fake_tenant.id, new_enabled])

          fake_tenant.update(new_enabled)
          service_mock.verify
        end

      end


      describe "#destroy" do

        let(:fake_tenant) {
          Fog::Identity::OpenStackCommon::Tenant.new(options.merge!('id' => fake_id))
        }

        it "calls destroy" do
          service_mock.expect(:delete_tenant, true, [fake_tenant.id])

          fake_tenant.destroy
          service_mock.verify
        end

      end


      describe "#users" do

        let(:fake_tenant) {
          Fog::Identity::OpenStackCommon::Tenant.new(options.merge!('id' => fake_id))
        }

        it "calls users" do
          service_mock.expect(:users, {}, [{:tenant_id => fake_tenant.id}])

          fake_tenant.users
          service_mock.verify
        end

      end


      describe "#to_s" do

        let(:fake_tenant) {
          Fog::Identity::OpenStackCommon::Tenant.new(options.merge!('id' => fake_id))
        }

        it "returns name" do
          fake_tenant.to_s.must_equal fake_name
        end

      end

    end
  end
end
