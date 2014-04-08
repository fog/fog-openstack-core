require_relative '../../../spec_helper'
require_relative '../../../support/spec_helpers'
include SpecHelpers

require 'fog/openstackcommon'

describe "requests" do
  describe "identity_v2" do
    describe "ec2 credential operations" do

      let(:admin_options) { admin_options_hash }

      let(:service) {
        Fog::OpenStackCommon::IdentityV2.new(admin_options)
      }

      describe "#list_ec2_credentials" do

        let(:user_id) { service.list_users.body['users'].first['id'] }

        it "with a valid user_id", :vcr do
          results = service.list_ec2_credentials(user_id)
          [200, 202].must_include results.status
        end

        it "with an invalid user_id", :vcr do
          proc {
            service.list_ec2_credentials(1234567890)
          }.must_raise Fog::OpenStackCommon::Errors::NotFound
        end

      end #list_ec2_credentials

      describe "#create_ec2_credential" do

        let(:user_id) { service.list_users.body['users'].first['id'] }
        let(:tenant_id) { service.list_users.body['users'].first['tenantId'] }

        it "with a valid user_id", :vcr do
          results = service.create_ec2_credential(user_id, tenant_id)
          [200, 202].must_include results.status
        end

        it "with an invalid user_id", :vcr do
          proc {
            service.create_ec2_credential("abcdefghijklmnopqrstuvwxyz", tenant_id)
          }.must_raise Fog::OpenStackCommon::Errors::NotFound
        end

        it "with an invalid tenant_id", :vcr do
          proc {
            service.create_ec2_credential(user_id, "abcdefghijklmnopqrstuvwxyz")
          }.must_raise Fog::OpenStackCommon::Errors::NotFound
        end

      end #create_ec2_credential

      describe "#get_ec2_credential" do

        let(:user_id) { service.list_users.body['users'].first['id'] }
        let(:access_key) { service.list_users.body['users'].first['password'] }

        it "with a valid user_id", :vcr do
          results = service.get_ec2_credential(user_id, access_key)
          [200, 202].must_include results.status
        end

        it "with an invalid user_id", :vcr do
          proc {
            service.get_ec2_credential("abcdefghijklmnopqrstuvwxyz", access_key)
          }.must_raise Fog::OpenStackCommon::Errors::NotFound
        end

        it "with an invalid access_key", :vcr do
          proc {
            service.get_ec2_credential(user_id, "abcdefghijklmnopqrstuvwxyz")
          }.must_raise Fog::OpenStackCommon::Errors::NotFound
        end

      end #get_ec2_credential

      describe "#delete_ec2_credential" do

        let(:user_id) { service.list_users.body['users'].first['id'] }
        let(:tenant_id) { service.list_users.body['users'].first['tenantId'] }

        it "with a valid user_id", :vcr do
          results = service.create_ec2_credential(user_id, tenant_id)
          access_key = results.body['credential']['access']
          results = service.delete_ec2_credential(user_id, access_key)
          [200, 204].must_include results.status
        end

        it "with an invalid user_id", :vcr do
          proc {
            results = service.create_ec2_credential(user_id, tenant_id)
            access_key = results.body['credential']['access']
            service.delete_ec2_credential("abcdefghijklmnopqrstuvwxyz", access_key)
          }.must_raise Fog::OpenStackCommon::Errors::NotFound
        end

        it "with an invalid access_key", :vcr do
          proc {
            service.delete_ec2_credential(user_id, "abcdefghijklmnopqrstuvwxyz")
          }.must_raise Fog::OpenStackCommon::Errors::NotFound
        end

      end #delete_ec2_credential

    end
  end
end
