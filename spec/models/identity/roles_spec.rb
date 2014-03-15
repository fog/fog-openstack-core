require_relative '../../spec_helper'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/roles'

describe "models" do
  describe "identity" do
    describe "roles" do

      let(:service_mock) { Minitest::Mock.new }

      let(:fake_id) { "1234567890" }

      let(:options) { {
        :service => service_mock
      } }

      let(:fake_roles_collection) {
        Fog::Identity::OpenStackCommon::Roles.new(options)
      }

      let(:fake_roles_response) {
        response = OpenStruct.new
        response.body = {'roles' => {}}
        response
      }

      before do
        # have to do this to handle fog-core check
        service_mock.expect(:nil?, false, [])
      end


      describe "#all" do

        it "gets all roles" do
          service_mock.expect(:list_roles, fake_roles_response, [])

          fake_roles_collection.all
        end

      end


      describe "#get" do

        let(:fake_role_response) {
          response = OpenStruct.new
          response.body = {'role' => {}}
          response
        }

        it "when role exists in collection" do
          service_mock.expect(:get_role, fake_role_response, [fake_id])

          fake_roles_collection.get(fake_id)
        end

      end

    end
  end
end
