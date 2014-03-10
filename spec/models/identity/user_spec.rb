require_relative '../../spec_helper'

require 'fog/openstackcommon'
require_relative '../../../lib/fog/openstackcommon/models/identity/user'

describe Fog::Identity::OpenStackCommon::User do

  let(:connect_options) { {
    :provider => 'OpenStackCommon',
    :openstack_auth_url => "http://devstack.local:5000/v2.0/tokens",
    :openstack_username => "admin",
    :openstack_api_key => "stack"
    } }

  let(:service) { Fog::Identity.new(connect_options) }

  let(:options) { {
    :service => service,
    :email => 'jsmith@acme.com',
    :enabled => true,
    :name => "John Smith #{Time.now.to_i}",
    :tenant_id => tenant_id,
    :password => 'password'
    } }

  let(:tenant_id) { service.list_tenants.body['tenants'].first['id'] }
  let(:user) { Fog::Identity::OpenStackCommon::User.new(options) }

  describe "#initialize", :vcr do

    describe "unsaved user" do

      it "must be of the correct type" do
        user.must_be_instance_of Fog::Identity::OpenStackCommon::User
      end

      it "must have correct email" do
        user.email.must_equal "jsmith@acme.com"
      end

      it "must be enabled" do
        user.enabled.must_equal true
      end

      it "must have correct name" do
        user.name.must_equal user.name
      end

      it "must have correct tenant_id" do
        user.tenant_id.must_equal tenant_id
      end

      it "must have correct password" do
        user.password.must_equal "password"
      end

    end

  end

  describe "#save", :vcr do

    it "calls create when user is new" do
      result = user.save
      result.must_equal true
    end

    it "calls update when user exists" do
      user.save
      result = user.save
      result.must_equal true
    end

  end

  describe "#update" do
    # it "calls create when user is new" do
    #   result = user.save
    #   result.must_equal true
    # end
  end

  describe "#update_password", :vcr do
    it "updates the password" do
      user.save
      result = user.update_password('password')
      result.must_equal true
      user.password.must_equal 'password'
    end
  end

  describe "#update_tenant", :vcr do

    let(:tenant) { service.create_tenant("azahabada#{Time.now.to_i}") }
    let(:tenant_id) { tenant.body['tenant']['id']}

    it "updates the tenantId" do
      user.save
      result = user.update_tenant(tenant_id)
      result.must_equal true
      user.tenant_id.must_equal tenant_id
    end
  end

  describe "#update_enabled", :vcr do
    it "updates the enabled flag" do
      user.save
      result = user.update_enabled(false)
      result.must_equal true
      user.enabled.must_equal false
    end
  end

  describe "#destroy", :vcr do
    it "calls update when user exists" do
      user.save
      result = user.destroy
      result.must_equal true
    end
  end


  # describe "#ec2_credentials" do
  #   let(:service) { MiniTest::Mock.new }
  #
  #   it "service receives the 'ec2_credentials' message" do
  #     service.expect(:ec2_credentials, true, [{ :user => user }])
  #     user.ec2_credentials
  #     service.verify
  #   end
  #
  # end


  describe "#roles", :vcr do
    it "returns list of user roles" do
      user.save
      roles_list = user.roles
      roles_list.must_be_instance_of Array
    end
  end

end
