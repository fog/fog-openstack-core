require_relative '../../../spec_helper'
require_relative '../../../support/spec_helpers'
include SpecHelpers

require 'fog/openstackcommon'

describe "requests" do
  describe "identity" do
    describe "v2" do
      describe "tenant operations" do

        let(:admin_options) { admin_options_hash }

        let(:service) {
          Fog::OpenStackCommon::IdentityV2.new(admin_options)
        }

        describe "#create_tenant" do

          describe "when a unique name specified", :vcr do

            let(:result) {
              service.create_tenant({'name' => "azahabada#{Time.now.to_i}"})
            }

            it "returns the proper status" do
              result.status.must_equal 200
            end

            it "returns valid tenant" do
              result.body['tenant'].wont_be_nil
            end
          end

          describe "when the name is missing" do

            it "raises an exception", :vcr do
              proc {
                service.create_tenant({})
              }.must_raise Fog::OpenStackCommon::IdentityV2::BadRequest
            end

          end

          describe "without name - with description" do

            it "raises an exception", :vcr do
              proc {
                service.create_tenant({'name' => nil, 'description' => "azahabada#{Time.now.to_i}"})
              }.must_raise Fog::OpenStackCommon::IdentityV2::BadRequest
            end

          end

          describe "when nil is passed instead of hash" do

            it "raises an exception", :vcr do
              proc {
                service.create_tenant(nil)
              }.must_raise Fog::OpenStackCommon::IdentityV2::BadRequest
            end

          end

        end

        describe "#update_tenant" do
          describe "when the tenant exists" do

            it "update name succeeds", :vcr do
              tenant = service.create_tenant({'name' => "azahabada#{Time.now.to_i}"})
              name = {'name' => "new-name#{Time.now.to_i}"}

              result = service.update_tenant(tenant.body['tenant']['id'], name)
              [200, 204].must_include result.status
            end

            it "update description succeeds", :vcr do
              tenant = service.create_tenant({'name' => "azahabada#{Time.now.to_i}"})
              description = {'description' => "new-description#{Time.now.to_i}"}

              result = service.update_tenant(tenant.body['tenant']['id'], description)
              [200, 204].must_include result.status
            end

            it "update enabled succeeds", :vcr do
              tenant = service.create_tenant({'name' => "azahabada#{Time.now.to_i}"})
              enabled = {'enabled' => false}

              result = service.update_tenant(tenant.body['tenant']['id'], enabled)
              [200, 204].must_include result.status
            end
          end

          describe "when the tenant doesnt exist" do
            it "returns not found error", :vcr do
              name = {'name' => "new-name#{Time.now.to_i}"}
              proc {
                service.update_tenant('bogus-tenant-id', name)
              }.must_raise Fog::OpenStackCommon::Errors::NotFound
            end
          end
        end

        describe "#delete_tenant" do

          it "when tenand id specified", :vcr do
            tenant = service.create_tenant({'name' => "azahabada#{Time.now.to_i}"})
            result = service.delete_tenant(tenant.body['tenant']['id'])
            [200, 204].must_include result.status
          end

          it "when invalid tenant id specified", :vcr do
            proc {
              service.delete_tenant("abcdefghijklmnopqrstuvwxyz")
            }.must_raise Fog::OpenStackCommon::Errors::NotFound
          end

        end

        describe "#list_tenants", :vcr do

        #         'tenants_links' => [],
        #         'tenants' => [
        #           {'id' => '1',
        #            'description' => 'Has access to everything',
        #            'enabled' => true,
        #            'name' => 'admin'},
        #           {'id' => '2',
        #            'description' => 'Normal tenant',
        #            'enabled' => true,
        #            'name' => 'default'},
        #           {'id' => '3',
        #            'description' => 'Disabled tenant',
        #            'enabled' => false,
        #            'name' => 'disabled'}
        #         ]
        #       },
        #       :status => [200, 204][rand(1)]

          let(:list) { service.list_tenants }

          it "returns valid status" do
            [200, 204].must_include list.status
          end

          it "returns tenant list" do
            list.body['tenants'].first['id'].wont_be_nil
          end

        end

        describe "#get_tenants_by_name" do

          let(:list) { service.list_tenants }

          it "when valid name specified", :vcr do
            name = list.body['tenants'].first['name']
            test_tenant = service.get_tenants_by_name(name)
            [200, 204].must_include test_tenant.status
          end

          it "when invalid name specified", :vcr do
            proc {
              service.get_tenants_by_name("missingtenant12345")
            }.must_raise Fog::OpenStackCommon::Errors::NotFound
          end

        end

        describe "#get_tenants_by_id" do

          let(:list) { service.list_tenants }

          it "when valid tenant id specified", :vcr do
            id = list.body['tenants'].first['id']
            test_tenant = service.get_tenants_by_id(id)
            [200, 204].must_include test_tenant.status
          end

          it "when invalid tenant id specified", :vcr do
            proc {
              service.get_tenants_by_id("123456789")
            }.must_raise Fog::OpenStackCommon::Errors::NotFound
          end

        end

        describe "#list_roles_for_user_on_tenant", :vcr do

          let(:list) { service.list_users }

          describe "when valid tenant id specified", :vcr do
            let(:tenant_id) { list.body['users'].first['tenantId'] }
            let(:user_id) { list.body['users'].first['id'] }
            let(:result) { service.list_roles_for_user_on_tenant(tenant_id, user_id) }

            it "returns a valid status" do
              [200, 204].must_include result.status
            end

            it "returns a list of roles" do
              roles_list = result.body['roles']
              roles_list.must_be_instance_of Array
            end
          end

          it "when invalid tenant id specified", :vcr do
            proc {
              user_id = list.body['users'].first['id']
              service.list_roles_for_user_on_tenant("1234567890", user_id)
            }.must_raise Fog::OpenStackCommon::Errors::NotFound
          end

        end

        describe "#list_users_for_tenant" do

          it "when valid tenant id specified", :vcr do
            tenant_id = service.list_tenants.body['tenants'].first['id']
            result = service.list_users_for_tenant(tenant_id)
            [200, 203].must_include result.status
          end

          it "when invalid tenant id specified", :vcr do
            proc {
              service.list_users_for_tenant("123456789")
            }.must_raise Fog::OpenStackCommon::Errors::NotFound
          end

        end

        describe "#add_role_to_user_on_tenant" do

          let(:role_response) { service.create_role("azahabada#{Time.now.to_i}") }

          it "when valid tenant, user, and role specified", :vcr do
            tenant_id = service.list_tenants.body['tenants'].first['id']
            user_id = service.list_users.body['users'].first['id']
            role_id = role_response[:body]['role']['id']

            result = service.add_role_to_user_on_tenant(tenant_id, user_id, role_id)
            [200, 201].must_include result.status
          end

        end

        describe "#delete_role_from_user_on_tenant" do

          let(:role_response) { service.create_role("azahabada#{Time.now.to_i}") }

          it "when valid tenant, user, and role specified", :vcr do
            tenant_id = service.list_tenants.body['tenants'].first['id']
            users_list = service.list_users_for_tenant(tenant_id).body['users']
            user_id = users_list.first['id']
            role_id = role_response[:body]['role']['id']
            new_role = service.add_role_to_user_on_tenant(tenant_id, user_id, role_id)

            result = service.delete_role_from_user_on_tenant(tenant_id, user_id, new_role.body['role']['id'])
            [200, 204].must_include result.status
          end

          it "when invalid role id specified", :vcr do
            proc {
              tenant_id = service.list_tenants.body['tenants'].first['id']
              users_list = service.list_users_for_tenant(tenant_id).body['users']
              user_id = users_list.first['id']

              service.delete_role_from_user_on_tenant(tenant_id, user_id, 'bogus-role-id')
            }.must_raise Fog::OpenStackCommon::Errors::NotFound
          end

        end

      end
    end
  end
end
