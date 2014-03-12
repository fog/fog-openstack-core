require_relative '../../spec_helper'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/user'

describe "models" do
  describe "identity" do
    describe "Fog::Identity::OpenStackCommon::User" do

      let(:connect_options) { {
        :provider => 'OpenStackCommon',
        :openstack_auth_url => "http://devstack.local:5000/v2.0/tokens",
        :openstack_username => "admin",
        :openstack_api_key => "stack"
        } }

      let(:service) { Fog::Identity.new(connect_options) }
      let(:user_name) { "John Smith #{Time.now.to_i}" }
      let(:tenant_id) { service.list_tenants.body['tenants'].first['id'] }

      let(:options) { {
        :service => service,
        :email => 'jsmith@acme.com',
        :enabled => true,
        :name => user_name,
        :tenant_id => tenant_id,
        :password => 'password'
        } }

      let(:unsaved_user) { Fog::Identity::OpenStackCommon::User.new(options) }

      describe "new user" do

        describe "#initialize", :vcr do

          it "must be of the correct type" do
            unsaved_user.must_be_instance_of Fog::Identity::OpenStackCommon::User
          end

          it "must have correct email" do
            unsaved_user.email.must_equal "jsmith@acme.com"
          end

          it "must be enabled" do
            unsaved_user.enabled.must_equal true
          end

          it "must have correct name" do
            unsaved_user.name.must_equal user_name
          end

          it "must have correct tenant_id" do
            unsaved_user.tenant_id.must_equal tenant_id
          end

          it "must have correct password" do
            unsaved_user.password.must_equal "password"
          end

        end

        describe "#save", :vcr do

          it "calls create when user is new" do
            result = unsaved_user.save
            result.must_equal true
          end

          it "calls update when user exists" do
            unsaved_user.save
            result = unsaved_user.save
            result.must_equal true
          end

        end

      end

      describe "existing user" do

        let(:saved_user) {
          user = Fog::Identity::OpenStackCommon::User.new(options)
          user.save
          user
        }

        describe "#update" do
        end

        describe "#update_password", :vcr do

          it "returns true" do
            result = saved_user.update_password('password')
            result.must_equal true
          end

          it "updates the password" do
            result = saved_user.update_password('password')
            saved_user.password.must_equal 'password'
          end

        end

        describe "#update_tenant", :vcr do

          let(:tenant) { service.create_tenant("azahabada#{Time.now.to_i}") }
          let(:tenant_id) { tenant.body['tenant']['id']}

          it "returns true" do
            result = saved_user.update_tenant(tenant_id)
            result.must_equal true
          end

          it "updates the tenantId" do
            result = saved_user.update_tenant(tenant_id)
            saved_user.tenant_id.must_equal tenant_id
          end

        end

        describe "#update_enabled", :vcr do

          it "returns true" do
            result = saved_user.update_enabled(false)
            result.must_equal true
          end

          it "updates the enabled flag" do
            result = saved_user.update_enabled(false)
            saved_user.enabled.must_equal false
          end

        end

        describe "#destroy", :vcr do

          it "calls update when user exists" do
            result = saved_user.destroy
            result.must_equal true
          end

        end

        describe "#ec2_credentials", :vcr do

          it "service receives the 'ec2_credentials' message" do
            creds = saved_user.ec2_credentials
            creds.must_be_instance_of Fog::Identity::OpenStackCommon::Ec2Credentials
          end

        end

        describe "#roles", :vcr do

          # ToDo: change this to get roles based on user_id and return collection
          # roles_list.must_be_instance_of Fog::Identity::OpenStackCommon::Roles
          it "returns an array" do
            roles_list = saved_user.roles
            roles_list.must_be_instance_of Array
          end

        end

      end

    end
  end
end
