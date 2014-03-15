require_relative '../../spec_helper'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/users'
require 'fog/openstackcommon/models/identity/user'

describe "models" do
  describe "identity" do
    describe "users" do

      let(:service_mock) { Minitest::Mock.new }

      let(:fake_id) { "1234567890" }

      let(:options) { {
        :service => service_mock,
        :tenant_id => fake_id
      } }

      let(:fake_users_collection) {
        Fog::Identity::OpenStackCommon::Users.new(options)
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


      describe "#find_by_id" do

        let(:fake_user_response) {
          response = OpenStruct.new
          response.body = {'user' => {}}
          response
        }

        it "when user exists in collection" do
          service_mock.expect(:list_users_for_tenant, fake_users_response, [fake_id])
          service_mock.expect(:get_user_by_id, fake_user_response, [fake_id])

          fake_users_collection.find_by_id(fake_id)
          service_mock.verify
        end

        # it "when user exists in openstack" do
        #   fake_users_collection.expect(:find_user_in_collection, nil, [fake_id])
        #   service_mock.expect(get_user_by_id, fake_user_response, [fake_id])
        #
        #   fake_users_collection.find_by_id(fake_id)
        # end

        # it "when user doesn't exist" do
        #   service_mock.expect(get_user_by_id, fake_user_response, [fake_id])
        #
        #   fake_users_collection.find_by_id(fake_id)
        # end

      end


      describe "#destroy" do
        it { skip("TBD") }
      #
      #   let(:user_mock) { MiniTest::Mock.new }
      #   # let(:options) { {
      #   # } }
      #   # let(:collection) { Fog::Identity::OpenStackCommon::Users.new(options) }
      #
      #   it "calls destroy" do
      #     user_mock.expect(:destroy, true, [fake_id])
      #
      #     user_mock.destroy(fake_id)
      #   end
      #
      end

    end
  end
end
