require_relative '../../spec_helper'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/tenant'
require 'fog/openstackcommon/models/identity/user'
require 'fog/openstackcommon/models/identity/role'

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
          }.must_raise ArgumentError
        end

        it "creates tenant when name is specified" do
          new_tenant = Fog::Identity::OpenStackCommon::Tenant.new(options)
          options.delete(:service)
          service_mock.expect(:create_tenant, fake_tenant_response, [options])

          new_tenant.save
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
        end

        it "updates description" do
          new_description = { 'description' => 'test123' }
          service_mock.expect(:update_tenant, fake_tenant_response, [fake_tenant.id, new_description])

          fake_tenant.update(new_description)
        end

        it "updates enabled" do
          new_enabled = { 'enabled' => false }
          service_mock.expect(:update_tenant, fake_tenant_response, [fake_tenant.id, new_enabled])

          fake_tenant.update(new_enabled)
        end

      end


      describe "#destroy" do

        let(:fake_tenant) {
          Fog::Identity::OpenStackCommon::Tenant.new(options.merge!('id' => fake_id))
        }

        it "calls destroy" do
          service_mock.expect(:delete_tenant, true, [fake_tenant.id])

          fake_tenant.destroy
        end

      end


      describe "#users" do

        let(:fake_tenant) {
          Fog::Identity::OpenStackCommon::Tenant.new(options.merge!('id' => fake_id))
        }

        it "calls users" do
          service_mock.expect(:users, {}, [{:tenant_id => fake_tenant.id}])

          fake_tenant.users
        end

      end

      describe "#roles_for" do

        let(:fake_tenant) {
          Fog::Identity::OpenStackCommon::Tenant.new(options.merge!('id' => fake_id))
        }

        let(:fake_user) {
          Fog::Identity::OpenStackCommon::User.new(options.merge!('id' => fake_id))
        }

        it "calls roles" do
          service_mock.expect(:roles, {}, [{:tenant => fake_tenant, :user => fake_user}])

          fake_tenant.roles_for(fake_user)
        end

      end

      describe "#grant_user_role" do

        let(:fake_tenant) {
          Fog::Identity::OpenStackCommon::Tenant.new(options.merge!('id' => fake_id))
        }

        let(:fake_user) {
          Fog::Identity::OpenStackCommon::User.new(options.merge!('id' => fake_id))
        }

        let(:fake_role) {
          Fog::Identity::OpenStackCommon::Role.new(options.merge!('id' => fake_id))
        }

        it "calls roles" do
          service_mock.expect(:add_user_to_tenant, {}, [fake_tenant.id, fake_user.id, fake_role.id])

          fake_tenant.grant_user_role(fake_user.id, fake_role.id)
        end

      end

      describe "#revoke_user_role" do

        let(:fake_tenant) {
          Fog::Identity::OpenStackCommon::Tenant.new(options.merge!('id' => fake_id))
        }

        let(:fake_user) {
          Fog::Identity::OpenStackCommon::User.new(options.merge!('id' => fake_id))
        }

        let(:fake_role) {
          Fog::Identity::OpenStackCommon::Role.new(options.merge!('id' => fake_id))
        }

        it "calls roles" do
          service_mock.expect(:remove_user_from_tenant, {}, [fake_tenant.id, fake_user.id, fake_role.id])

          fake_tenant.revoke_user_role(fake_user.id, fake_role.id)
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
