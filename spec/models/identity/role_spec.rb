require_relative '../../spec_helper'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/role'

describe "models" do
  describe "identity" do
    describe "Fog::Identity::OpenStackCommon::Role" do

      before do
        connect_options = {
          :provider => 'OpenStackCommon',
          :openstack_auth_url => "http://devstack.local:5000/v2.0/tokens",
          :openstack_username => "admin",
          :openstack_api_key => "stack"
          }
        service = Fog::Identity.new(connect_options)

        @role_name = "Role-#{Time.now.to_i}"
        options = {
          :service => service,
          :name => @role_name
        }
        @role = Fog::Identity::OpenStackCommon::Role.new(options)
      end

      describe "#initialize", :vcr do

        describe "unsaved Role" do

          it "must be of the correct type" do
            @role.must_be_instance_of Fog::Identity::OpenStackCommon::Role
          end

          it "must have correct name" do
            @role.name.must_equal @role_name
          end

        end

      end

      describe "#save", :vcr do

        it "calls create when role is new" do
          result = @role.save
          result.must_equal true
        end

        it "calls update when role exists" do
          proc {
            @role.save
            @role.save
          }.must_raise Fog::Identity::OpenStackCommon::Conflict
        end

      end

      describe "#destroy" do

        it "succeeds", :vcr do
          @role.save
          result = @role.destroy
          result.must_equal true
        end

        it "fails", :vcr do
          proc {
            @role.save
            @role.destroy
            @role.destroy
          }.must_raise Fog::Identity::OpenStackCommon::NotFound
        end

      end

    end
  end
end
