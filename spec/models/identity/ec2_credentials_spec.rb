require_relative '../../spec_helper'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/user'
require 'fog/openstackcommon/models/identity/ec2_credential'
require 'fog/openstackcommon/models/identity/ec2_credentials'

describe "models" do
  describe "identity" do
    describe "ec2_credentials" do

      let(:service_mock) { Minitest::Mock.new }

      let(:fake_id) { "1234567890" }

      let(:fake_user){ Fog::Identity::OpenStackCommon::User.new(
        :service => service_mock,
        'id' => fake_id,
        'name' => "John Smith #{Time.now.to_i}",
        'password' => 'password',
        'email' => 'jsmith@acme.com',
        'tenant_id' => 'tenant12345',
        'enabled' => true
        ) }

      let(:options) { {
        :service => service_mock,
        :tenant_id => fake_id
      } }

      let(:fake_credentials_collection) {
        Fog::Identity::OpenStackCommon::Ec2Credentials.new(options)
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

      describe "#find_by_access_key" do

        let(:fake_credential_response) {
          response = OpenStruct.new
          response.body = {'credential' => {}}
          response
        }

        describe "without user specified" do
          it "returns an empty array" do
            result = fake_credentials_collection.find_by_access_key(fake_id)
            result.must_equal nil
          end
        end

        describe "with user specified" do
          it { skip("TBD") }
          # it "gets credential" do
          #   service_mock.expect(:get_ec2_credential, nil, [fake_id, fake_id])
          #   fake_credentials_collection.find_by_access_key(fake_id)
          #   service_mock.verify
          # end
        end


      end
    end
  end
end
