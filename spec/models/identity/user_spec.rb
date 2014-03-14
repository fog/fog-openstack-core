require_relative '../../spec_helper'
require 'ostruct'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/user'

describe "models" do
  describe "identity" do
    describe "user" do

      let(:service_mock) { Minitest::Mock.new }

      let(:fake_id) { "1234567890" }
      let(:fake_name) { "John Smith #{Time.now.to_i}" }
      let(:fake_password) { 'password' }
      let(:fake_email) { 'jsmith@acme.com' }
      let(:fake_tenant_id) { 'tenant12345' }
      let(:fake_enabled) { true }

      let(:options) { {
        :service => service_mock,
        'name' => fake_name,
        'password' => fake_password,
        'email' => fake_email,
        'tenant_id' => fake_tenant_id,
        'enabled' => fake_enabled
      } }

      let(:fake_user_response) {
        response = OpenStruct.new
        response.body = {'user' => {}}
        response
      }

      before do
        # have to do this to handle fog-core check
        service_mock.expect(:nil?, false, [])
      end

      describe "#initialize" do

        it "throws exception when name is missing" do
          proc {
            options.delete('name')
            new_user = Fog::Identity::OpenStackCommon::User.new(options)
            service_mock.expect(:create_user, {}, [nil, fake_password, fake_email, fake_tenant_id, fake_enabled])

            new_user.save
          }.must_raise ArgumentError
        end

        it "throws exception when password is missing" do
          proc {
            options.delete('password')
            new_user = Fog::Identity::OpenStackCommon::User.new(options)
            service_mock.expect(:create_user, {}, [fake_name, nil, fake_email, fake_tenant_id, fake_enabled])

            new_user.save
          }.must_raise ArgumentError
        end

        it "throws exception when tenant id is missing" do
          proc {
            options.delete('tenant_id')
            new_user = Fog::Identity::OpenStackCommon::User.new(options)
            service_mock.expect(:create_user, {}, [fake_name, fake_password, fake_email, nil, fake_enabled])

            new_user.save
          }.must_raise ArgumentError
        end

        it "sets enabled to true when enabled is missing" do
          options.delete('enabled')
          new_user = Fog::Identity::OpenStackCommon::User.new(options)
          service_mock.expect(:create_user, fake_user_response, [fake_name, fake_password, fake_email, fake_tenant_id, nil])

          new_user.save
        end

        it "creates user when name, password and tenant_id specified" do
          new_user = Fog::Identity::OpenStackCommon::User.new(options)
          service_mock.expect(:create_user, fake_user_response, [fake_name, fake_password, fake_email, fake_tenant_id, fake_enabled])

          new_user.save
        end

      end


      describe "#save" do

        describe "with a new user" do

          let(:unsaved_user) { Fog::Identity::OpenStackCommon::User.new(options) }

          it "creates user" do
            service_mock.expect(:create_user, fake_user_response, [fake_name, fake_password, fake_email, fake_tenant_id, fake_enabled])

            unsaved_user.save
          end

        end

        describe "with an existing user" do

          let(:fake_user) {
            Fog::Identity::OpenStackCommon::User.new(options.merge!('id' => fake_id))
          }

          it "updates user" do
            service_mock.expect(:update_user, fake_user_response, [fake_user.id, {}])

            fake_user.save
          end

        end

      end


      describe "#update_password" do

        let(:fake_user) {
          Fog::Identity::OpenStackCommon::User.new(options.merge!('id' => fake_id))
        }

        it "calls update_password" do
          new_password = "secret"
          params_hash = {'password' => new_password}
          service_mock.expect(:update_user, fake_user_response, [fake_user.id, params_hash])

          fake_user.update_password(new_password)
        end

      end


      describe "#update_tenant" do

        let(:fake_user) {
          Fog::Identity::OpenStackCommon::User.new(options.merge!('id' => fake_id))
        }

        it "calls update_tenant" do
          new_tenant = "NewTenant"
          params_hash = {'tenantId' => new_tenant}
          service_mock.expect(:update_user, fake_user_response, [fake_user.id, params_hash])

          fake_user.update_tenant(new_tenant)
        end

      end


      describe "#update_enabled" do

        let(:fake_user) {
          Fog::Identity::OpenStackCommon::User.new(options.merge!('id' => fake_id))
        }

        it "calls enable_user" do
          enabled = false
          params_hash = {'enabled' => enabled}
          service_mock.expect(:update_user, fake_user_response, [fake_user.id, params_hash])

          fake_user.update_enabled(enabled)
        end

      end


      describe "#destroy" do

        let(:fake_user) {
          Fog::Identity::OpenStackCommon::User.new(options.merge!('id' => fake_id))
        }

        it "calls destroy" do
          service_mock.expect(:delete_user, true, [fake_user.id])

          fake_user.destroy
        end

      end


      describe "#ec2_credentials" do

        let(:fake_user) {
          Fog::Identity::OpenStackCommon::User.new(options.merge!('id' => fake_id))
        }

        it "calls ec2_credentials" do
          service_mock.expect(:ec2_credentials, {}, [{:user => fake_user}])

          fake_user.ec2_credentials
        end

      end


      describe "#roles" do

        let(:fake_user) {
          Fog::Identity::OpenStackCommon::User.new(options.merge!('id' => fake_id))
        }

        let(:roles_response) {
          roles_response = OpenStruct.new
          roles_response.body = {'roles' => {}}
          roles_response
        }

        it "calls roles" do
          service_mock.expect(:list_roles_for_user_on_tenant, roles_response, [fake_tenant_id, fake_id])

          fake_user.roles
        end

      end

    end
  end
end
