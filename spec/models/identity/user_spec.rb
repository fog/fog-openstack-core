require_relative '../../spec_helper'

require 'fog/openstackcommon'
require_relative '../../../lib/fog/openstackcommon/models/identity/user'

describe Fog::Identity::OpenStackCommon::User do
  let (:options) {
    { :email => 'jsmith@acme.com',
      :enabled => true,
      :name => 'John Smith',
      :tenant_id => '123456789',
      :password => 'password'
      } }
  let (:user) {
    Fog::Identity::OpenStackCommon::User.new(options) }

  describe ".initialize" do

    it "must not be nil" do
      user.wont_be_nil
    end

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
      user.name.must_equal "John Smith"
    end

    it "must have correct tenant_id" do
      user.tenant_id.must_equal "123456789"
    end

    it "must have correct password" do
      user.password.must_equal "password"
    end

  end

  describe ".ec2_credentials" do
    let(:service) { MiniTest::Mock.new }

    it "service receives the 'ec2_credentials' message" do
      service.expect(:ec2_credentials, true, [{ :user => user }])
      user.ec2_credentials
      service.verify
    end

  end

  def ec2_credentials
    requires :id
    service.ec2_credentials(:user => self)
  end

  describe ".save" do
    it { skip("TBD") }
  end

  describe ".update" do
    it { skip("TBD") }
  end

  describe ".update_password" do
    it { skip("TBD") }
  end

  describe ".update_tenant" do
    it { skip("TBD") }
  end

  describe ".update_enabled" do
    it { skip("TBD") }
  end

  describe ".destroy" do
    it { skip("TBD") }
  end

  describe ".roles" do
    it { skip("TBD") }
  end

end
