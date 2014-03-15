require_relative '../../spec_helper'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/ec2_credential'

describe "models" do
  describe "identity" do
    describe "ec2_credential" do

      let(:service_mock) { Minitest::Mock.new }

      let(:fake_access) { "access123" }
      let(:fake_password) { "password123" }
      let(:fake_tenant_id) { "tenant123" }
      let(:fake_user_id) { "user123" }

      let(:options) { {
        :service => service_mock,
        :secret => fake_password,
        :tenant_id => fake_tenant_id,
        :user_id => fake_user_id
        } }

      let(:fake_credential_response) {
        response = OpenStruct.new
        response.body = {'credential' => {}}
        response
      }

      before do
        # have to do this to handle fog-core check
        service_mock.expect(:nil?, false, [])
      end

      describe "#save" do

        it "throws exception when user_id is missing" do
          proc {
            options.delete(:user_id)
            new_credential = Fog::Identity::OpenStackCommon::Ec2Credential.new(options)
            options.delete(:service)
            service_mock.expect(:create_ec2_credential, {}, [fake_user_id, fake_tenant_id])

            new_credential.save
          }.must_raise ArgumentError
        end

        it "throws exception when tenant_id is missing" do
          proc {
            options.delete(:tenant_id)
            new_credential = Fog::Identity::OpenStackCommon::Ec2Credential.new(options)
            options.delete(:service)
            service_mock.expect(:create_ec2_credential, {}, [fake_user_id, fake_tenant_id])

            new_credential.save
          }.must_raise ArgumentError
        end

        it "creates credential when user_id, tenant_id specified" do
          new_credential = Fog::Identity::OpenStackCommon::Ec2Credential.new(options)
          options.delete(:service)
          service_mock.expect(:create_ec2_credential, fake_credential_response, [new_credential.user_id, new_credential.tenant_id])

          new_credential.save
        end

      end


      describe "#destroy" do

        let(:fake_credential) {
          Fog::Identity::OpenStackCommon::Ec2Credential.new(options.merge!('access' => fake_access))
        }

        it "calls destroy" do
          service_mock.expect(:delete_ec2_credential, true, [fake_user_id, fake_access])

          fake_credential.destroy
        end

      end


    end
  end
end
