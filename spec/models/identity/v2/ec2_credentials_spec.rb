require File.dirname(__FILE__) + '/../../../spec_helper'

require 'fog/openstackcore'
require 'fog/openstackcore/services/identity_v2'
require 'fog/openstackcore/models/identity/v2/user'
require 'fog/openstackcore/models/identity/v2/ec2_credential'
require 'fog/openstackcore/models/identity/v2/ec2_credentials'

describe "models" do
  describe "identity_v2" do
    describe "ec2_credentials" do

      let(:service_mock) { Minitest::Mock.new }

      let(:fake_id) { "1234567890" }

      let(:fake_user){ Fog::OpenStackCore::IdentityV2::User.new(
        :service => service_mock,
        'id' => fake_id,
        'name' => "John Smith #{Time.now.to_i}",
        'password' => 'password',
        'email' => 'jsmith@acme.com',
        'tenant_id' => 'tenant12345',
        'enabled' => true
        ) }

      let(:options) {
        { :service => service_mock,
          :tenant_id => fake_id
        }
      }

      let(:fake_credentials_collection) {
        Fog::OpenStackCore::IdentityV2::Ec2Credentials.new(options)
      }

      let(:fake_credentials_response) {
        response = OpenStruct.new
        response.body = {'credentials' => {}}
        response
      }

      describe "#all" do
        describe "without user specified" do
          it "returns an empty array" do
            result = fake_credentials_collection.all
            result.must_equal []
          end
        end
        describe "with user specified" do
          it "gets all credentials" do

          end
        end
      end

      describe "#create" do
        it { skip("Handled by fog framework") }
      end

      describe "#destroy" do
        it { skip("TBD") }
      end

    end
  end
end
