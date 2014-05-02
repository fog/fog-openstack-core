require_relative '../../../spec_helper'
require_relative '../../../support/spec_helpers'
include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/identity_v2'

describe "requests" do
  describe "identity_v2" do
    describe "token operations" do

      let(:admin_options) { admin_options_hash }

      let(:service) {
        Fog::OpenStackCore::IdentityV2.new(admin_options)
      }

      let(:tenant_id) {
        data = service.get_tenants_by_name(admin_options_hash[:openstack_tenant])
        data.body['tenant']['id']
      }

      let(:valid_token_id) { service.identity_session.auth_token }

      describe "#create_token", :vcr do

        let(:result) {
          service.create_token(
            admin_options[:openstack_username],
            admin_options[:openstack_api_key])
        }

        it "returns correct status" do
          [200, 203].must_include result.status
        end

        it "returns valid token" do
          token = result.body['access']['token']['id']

          token.wont_be_nil
        end

      end

      describe "#check_token" do

        describe "with a valid token and tenant id" do

          it "succeeds", :vcr do
            result = service.check_token(valid_token_id, tenant_id)

            [200, 203, 204].must_include result.status
          end

        end

        describe "with tenant name (not ID)" do

          it "fails", :vcr do
            tenant_name = admin_options_hash[:openstack_tenant]

            proc {
              service.check_token(valid_token_id, tenant_name)
            }.must_raise Excon::Errors::Unauthorized
          end

        end

        describe "with an invalid token and tenant id" do

          it "fails", :vcr do
            token_id = "abcdefghijklmnopqrstuvwxyz"
            tenant_id = "dummy"

            proc {
              service.check_token(token_id, tenant_id)
            }.must_raise Fog::OpenStackCore::Errors::NotFound
          end

        end

      end

      describe "#validate_token" do

        it "when token and tenant specified", :vcr do
          result = service.validate_token(valid_token_id, tenant_id)

          [200, 203].must_include result.status
        end

        it "when token and tenant are invalid", :vcr do
          token_id = "abcdefghijklmnopqrstuvwxyz"
          tenant_id = "dummy"

          proc {
            service.validate_token(token_id, tenant_id)
          }.must_raise Fog::OpenStackCore::Errors::NotFound
        end

      end

      describe "#list_endpoints_for_token", :vcr do

        let(:response) { service.list_endpoints_for_token(service.identity_session.auth_token) }

        it "returns a hash" do
          response.body.must_be_instance_of Hash
        end

        it "returns a valid response" do
          [200, 203].must_include response.status
        end

      end

    end
  end
end
