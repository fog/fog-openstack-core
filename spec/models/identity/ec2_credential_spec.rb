require_relative '../../spec_helper'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/ec2_credential'

describe "models" do
  describe "identity" do
    describe "Fog::Identity::OpenStackCommon::Ec2Credential" do

      before do
        connect_options = {
          :provider => 'OpenStackCommon',
          :openstack_auth_url => "http://devstack.local:5000/v2.0/tokens",
          :openstack_username => "admin",
          :openstack_api_key => "stack"
          }
        service = Fog::Identity.new(connect_options)

        tenant_id = service.list_tenants.body['tenants'].first['id']
        valid_options = {
          :service => service,
          :email => 'jsmith@acme.com',
          :enabled => true,
          :name => "John Smith #{Time.now.to_i}",
          :tenant_id => tenant_id,
          :password => 'password'
        }

        @user = service.users.create(valid_options)
        @ec2_credential = service.ec2_credentials.create({
          :user_id   => @user.id,
          :tenant_id => tenant_id,
        })
      end

      after do
        @user.ec2_credentials.each { |cred| cred.destroy }
        @user.destroy
      end

      describe "#destroy" do

        it "responds with true", :vcr do
          result = @ec2_credential.destroy
          result.must_equal true
        end

        it "responds with a NotFound error", :vcr do
          proc {
            @ec2_credential.destroy
            @ec2_credential.destroy
          }.must_raise Fog::Identity::OpenStackCommon::NotFound
        end

      end

    end
  end
end
