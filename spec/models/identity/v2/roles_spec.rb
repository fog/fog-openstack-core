require File.dirname(__FILE__) + '/../../../spec_helper'

require 'fog/openstackcore'
require 'fog/openstackcore/services/identity_v2'
require 'fog/openstackcore/models/identity/v2/roles'

require 'ostruct'

describe "models" do
  describe "identity_v2" do
    describe "roles" do

      let(:service_mock) { Minitest::Mock.new }

      let(:fake_id) { "1234567890" }

      let(:options) {
        { :service => service_mock }
      }

      let(:fake_roles_collection) {
        Fog::OpenStackCore::IdentityV2::Roles.new(options)
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
