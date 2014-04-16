require_relative '../../../spec_helper'

require 'fog/openstackcore'
require 'fog/openstackcore/models/identity/v2/users'
require 'fog/openstackcore/models/identity/v2/user'

require 'ostruct'

describe "models" do
  describe "identity_v2" do
    describe "users" do

      let(:service_mock) { Minitest::Mock.new }

      let(:fake_id) { "1234567890" }

      let(:options) {
        { :service => service_mock,
          :tenant_id => fake_id
        }
      }

      let(:fake_users_collection) {
        Fog::OpenStackCore::IdentityV2::Users.new(options)
      }

      let(:fake_users_response) {
        response = OpenStruct.new
        response.body = {'users' => {}}
        response
      }


      describe "#all" do

        it "gets all users" do
          service_mock.expect(:list_users_for_tenant, fake_users_response, [fake_id])

          fake_users_collection.all
          service_mock.verify
        end

      end


      describe "#destroy" do
        it { skip("TBD") }
      end

    end
  end
end
