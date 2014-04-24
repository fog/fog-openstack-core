require_relative '../../../spec_helper'
require 'ostruct'

require 'fog/openstackcore'
require 'fog/openstackcore/services/identity_v2'
require 'fog/openstackcore/models/identity/v2/tenant'
require 'fog/openstackcore/models/identity/v2/user'
require 'fog/openstackcore/models/identity/v2/role'

require 'ostruct'

describe "models" do
  describe "identity_v2" do
    describe "user" do

      let(:service_mock) { Minitest::Mock.new }

      let(:fake_id) { "1234567890" }
      let(:fake_name) { "John-Smith-#{Time.now.to_i}" }
      let(:fake_password) { 'password' }
      let(:fake_email) { 'jsmith@acme.com' }
      let(:fake_tenant_id) { 'tenant12345' }
      let(:fake_role_id) { 'role12345' }
      let(:fake_enabled) { true }

      let(:options) {
        { :service => service_mock,
          :name => fake_name,
          :password => fake_password,
          :email => fake_email,
          :tenant_id => fake_tenant_id,
          :enabled => fake_enabled
        }
      }

      let(:fake_user) {
        Fog::OpenStackCore::IdentityV2::User.new(
          options.merge!('id' => fake_id))
      }

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
            options.delete(:name)
            new_user = Fog::OpenStackCore::IdentityV2::User.new(options)
            service_mock.expect(
              :create_user,
              {},
              [nil, fake_password, fake_email, fake_tenant_id, fake_enabled])

            new_user.save
            service_mock.verify
          }.must_raise ArgumentError
        end

        it "throws exception when password is missing" do
          proc {
            options.delete(:password)
            new_user = Fog::OpenStackCore::IdentityV2::User.new(options)
            service_mock.expect(
              :create_user,
              {},
              [fake_name, nil, fake_email, fake_tenant_id, fake_enabled])

            new_user.save
            service_mock.verify
          }.must_raise ArgumentError
        end

        it "throws exception when tenant id is missing" do
          proc {
            options.delete(:tenant_id)
            new_user = Fog::OpenStackCore::IdentityV2::User.new(options)
            service_mock.expect(
              :create_user,
              {},
              [fake_name, fake_password, fake_email, nil, fake_enabled])

            new_user.save
            service_mock.verify
          }.must_raise ArgumentError
        end

        it "sets enabled to true when enabled is missing" do
          options.delete(:enabled)
          new_user = Fog::OpenStackCore::IdentityV2::User.new(options)
          service_mock.expect(
            :create_user,
            fake_user_response,
            [fake_name, fake_password, fake_email, fake_tenant_id, true])

          new_user.save
          service_mock.verify
        end

        it "creates user when name, password and tenant_id specified" do
          new_user = Fog::OpenStackCore::IdentityV2::User.new(options)
          service_mock.expect(
            :create_user,
            fake_user_response,
            [fake_name, fake_password, fake_email, fake_tenant_id, fake_enabled])

          new_user.save
          service_mock.verify
        end

      end

      describe "create" do

        let(:unsaved_user) { Fog::OpenStackCore::IdentityV2::User.new(options) }

        it "creates user" do
          service_mock.expect(
            :create_user,
            fake_user_response,
            [fake_name, fake_password, fake_email, fake_tenant_id, fake_enabled])

          unsaved_user.save
          service_mock.verify
        end

      end # create


      describe "update" do

        let(:expected_options) { options.clone }

        it "password" do
          expected_options.delete(:service)
          expected_options.merge!(:password => 'secret')
          expected_options.merge!(:id => fake_id)

          service_mock.expect(
            :update_user,
            fake_user_response,
            [fake_user.id, expected_options]
          )

          fake_user.password = expected_options[:password]
          fake_user.save
          service_mock.verify
        end

        it "tenant" do
          expected_options.delete(:service)
          expected_options.merge!(:tenant_id => 'NewTenant')
          expected_options.merge!(:id => fake_id)

          service_mock.expect(
            :update_user,
            fake_user_response,
            [fake_user.id, expected_options])

          fake_user.tenant_id = expected_options[:tenant_id]
          fake_user.save
          service_mock.verify
        end

        it "enabled" do
          expected_options.delete(:service)
          expected_options.merge!(:enabled => false)
          expected_options.merge!(:id => fake_id)

          service_mock.expect(
            :update_user,
            fake_user_response,
            [fake_user.id, expected_options])

          fake_user.enabled = expected_options[:enabled]
          fake_user.save
          service_mock.verify
        end

      end # update

      describe "#destroy" do

        let(:fake_user) {
          Fog::OpenStackCore::IdentityV2::User.new(
            options.merge!('id' => fake_id))
        }

        it "calls destroy" do
          service_mock.expect(
            :delete_user,
            true,
            [fake_user.id])

          fake_user.destroy
          service_mock.verify
        end

      end


      describe "#ec2_credentials" do

        let(:fake_user) {
          Fog::OpenStackCore::IdentityV2::User.new(
            options.merge!('id' => fake_id))
        }

        it "calls ec2_credentials" do
          service_mock.expect(
            :ec2_credentials,
            {},
            [{:user => fake_user}])

          fake_user.ec2_credentials
          service_mock.verify
        end

      end


      describe "#roles" do

        let(:fake_user) {
          Fog::OpenStackCore::IdentityV2::User.new(
            options.merge!('id' => fake_id))
        }

        let(:roles_response) {
          roles_response = OpenStruct.new
          roles_response.body = {'roles' => {}}
          roles_response
        }

        it "calls roles" do
          service_mock.expect(
            :list_roles_for_user_on_tenant,
            roles_response,
            [fake_tenant_id, fake_id])

          fake_user.roles
          service_mock.verify
        end

      end


      describe "#grant_role" do

        let(:fake_tenant) { OpenStruct.new({'id' => fake_tenant_id }) }
        let(:fake_role) { OpenStruct.new({'id' => fake_role_id }) }
        let(:fake_user) {
          Fog::OpenStackCore::IdentityV2::User.new(
            options.merge!('id' => fake_id))
        }

        it "grants role" do
          service_mock.expect(
            :add_role_to_user_on_tenant,
            {},
            [fake_tenant.id, fake_user.id, fake_role.id])

          fake_user.grant_role(fake_role.id)
          service_mock.verify
        end

      end # grant_role

      describe "#revoke_role" do

        let(:fake_tenant) { OpenStruct.new({'id' => fake_tenant_id }) }
        let(:fake_role) { OpenStruct.new({'id' => fake_role_id }) }
        let(:fake_user) {
          Fog::OpenStackCore::IdentityV2::User.new(
            options.merge!('id' => fake_id))
        }

        it "revokes role" do
          service_mock.expect(
            :delete_role_from_user_on_tenant,
            {},
            [fake_tenant.id, fake_user.id, fake_role.id])

          fake_user.revoke_role(fake_role.id)
          service_mock.verify
        end
      end # revoke_role

    end
  end
end
