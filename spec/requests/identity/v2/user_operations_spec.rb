require_relative '../../../spec_helper'
require_relative '../../../support/spec_helpers'
include SpecHelpers

require 'fog/openstackcommon'

describe "requests" do
  describe "identity_v2" do
    describe "user operations" do

      let(:admin_options) { admin_options_hash }

      let(:service) { Fog::OpenStackCommon::IdentityV2.new(admin_options) }

      describe "#list_users" do

        let(:list) { service.list_users }

        it "returns proper status", :vcr do
          assert_includes([200, 204], list.status)
        end
      end

      describe "#create_user", :vcr do

        it "when correct params specified" do
          name = "jsmith#{Time.now.to_i}"
          password = "password!"
          tenant_id = service.list_tenants.body['tenants'].first['id']
          email = "jsmith#{Time.now.to_i}@acme.com"
          enabled = true

          result = service.create_user(name, password, email, tenant_id, enabled)
          assert_includes([200, 201], result.status)
        end

      end

      describe "#update_user", :vcr do

        before do
          name = "jsmith#{Time.now.to_i}"
          password = "password!"
          tenant_id = service.list_tenants.body['tenants'].first['id']
          email = "jsmith#{Time.now.to_i}@acme.com"
          enabled = true
          result = service.create_user(name, password, email, tenant_id, enabled)
          @user_id = result.body['user']['id']
        end

        describe "when updating" do

          it "name" do
            result = service.update_user(@user_id, { 'name' => "bob#{Time.now.to_i}"})
            result.status.must_equal 200
          end

          it "username" do
            result = service.update_user(@user_id, { 'username' => "bob#{Time.now.to_i}"})
            result.status.must_equal 200
          end

          it "enabled" do
            result = service.update_user(@user_id, { 'enabled' => false })
            result.status.must_equal 200
          end

          it "email" do
            result = service.update_user(@user_id, { 'email' => "larry-#{Time.now.to_i}@acme.com"})
            result.status.must_equal 200
          end

        end

        describe "readonly attribs" do

          it "when updating tenant_id" do
            proc {
              service.update_user(@user_id, { 'tenant_id' => "dummy-tenantId"})
            }.must_raise Fog::OpenStackCommon::Errors::NotFound
          end

          # Although the user id is a readonly attribute, no need to write a spec against
          # the id because it is set with the 'update_user' request (update_user.rb); as a
          # result, the user will *never* be able to update the id.

        end

      end

      describe "#get_user_by_name" do

        it "when valid username specified", :vcr do
          user_list = service.list_users
          valid_user_name = user_list.body['users'].first["username"]
          result = service.get_user_by_name(valid_user_name)
          result.status.must_equal 200
        end

        it "when invalid username specified", :vcr do
          proc {
            service.get_user_by_name("nonexistentuser12345")
          }.must_raise Fog::OpenStackCommon::Errors::NotFound
        end

      end

      describe "#get_user_by_id" do

        it "when valid user id specifid", :vcr do
          valid_user_id = service.list_users.body['users'].first["id"]
          result = service.get_user_by_id(valid_user_id)
          result.status.must_equal 200
        end

        it "when invalid id specified", :vcr do
          proc {
            service.get_user_by_id("nonexistentuser12345")
          }.must_raise Fog::OpenStackCommon::Errors::NotFound
        end

      end

      describe "#delete_user" do
        before do
          name = "jsmith#{Time.now.to_i}"
          password = "password!"
          tenant_id = service.list_tenants.body['tenants'].first['id']
          email = "jsmith#{Time.now.to_i}@acme.com"
          enabled = true
          result = service.create_user(name, password, email, tenant_id, enabled)
          @user_id = result.body['user']['id']
        end

        it "when valid user id specified", :vcr do
          result = service.delete_user(@user_id)
          result.status.must_equal 204
        end

        it "when invalid user id specified", :vcr do
          proc {
            service.delete_user("1234567890")
          }.must_raise Fog::OpenStackCommon::Errors::NotFound
        end
      end

      describe "#enable_user" do
        before do
          name = "jsmith#{Time.now.to_i}"
          password = "password!"
          tenant_id = service.list_tenants.body['tenants'].first['id']
          email = "jsmith#{Time.now.to_i}@acme.com"
          enabled = false
          result = service.create_user(name, password, email, tenant_id, enabled)
          @user_id = result.body['user']['id']
        end

        it "when valid user id specified", :vcr do
          result = service.enable_user(@user_id, true)
          [200, 204].must_include result.status
        end

        it "when valid user id specified", :vcr do
          result = service.enable_user(@user_id, false)
          [200, 204].must_include result.status
        end

      end

      describe "#list_global_roles_for_user" do
        it { skip("API returns NotImplemented") }
      end

      describe "#list_user_global_roles" do
        it { skip("API returns NotImplemented") }
      end

      describe "#delete_global_role_for_user" do
        it { skip("API returns NotImplemented") }
      end

      describe "#add_global_role_to_user" do
        it { skip("API returns NotImplemented") }
      end

      describe "#add_credential_to_user" do
        it { skip("API returns NotImplemented") }
      end

      describe "#get_user_credentials", :vcr do
        it { skip("API returns NotImplemented") }
      end

      describe "#update_credential_for_user" do
        it { skip("API returns NotImplemented") }
      end

      describe "#delete_credential_for_user" do
        it { skip("API returns NotImplemented") }
      end

    end
  end
end
