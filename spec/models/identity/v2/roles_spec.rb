require_relative '../../../spec_helper'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/v2/roles'

describe "models" do
  describe "identity" do
    describe "v2" do
      describe "roles" do

        let(:service_mock) { Minitest::Mock.new }

        let(:fake_id) { "1234567890" }

        let(:options) {
          { :service => service_mock }
        }

        let(:fake_roles_collection) {
          Fog::IdentityV2::OpenStackCommon::Roles.new(options)
        }

        let(:fake_roles_response) {
          response = OpenStruct.new
          response.body = {'roles' => {}}
          response
        }

        describe "#all" do

          it "gets all roles" do
            service_mock.expect(:list_roles, fake_roles_response, [])

            fake_roles_collection.all
            service_mock.verify
          end

        end

      end
    end
  end
end
