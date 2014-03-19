require_relative '../../spec_helper'

require 'fog/openstackcommon'
require 'fog/openstackcommon/models/identity/role'
require 'fog/openstackcommon/models/identity/user'
require 'fog/openstackcommon/models/identity/tenant'

describe "models" do
  describe "identity" do
    describe "role" do

      let(:service_mock) { Minitest::Mock.new }

      let(:fake_id) { "1234567890" }
      let(:fake_name) { "Role-#{Time.now.to_i}" }

      let(:options) {
        { :service => service_mock,
          'name' => fake_name
        }
      }

      let(:fake_role_response) {
        response = OpenStruct.new
        response.body = {'role' => {}}
        response
      }

      before do
        # have to do this to handle fog-core check
        service_mock.expect(:nil?, false, [])
      end


      describe "#initialize" do

        it "throws exception when name is missing" do
          proc {
            options.delete('name')
            new_role = Fog::Identity::OpenStackCommon::Role.new(options)
            service_mock.expect(:create_role, {}, [nil])

            new_role.save
            service_mock.verify
          }.must_raise ArgumentError
        end

        it "creates role when name specified" do
          new_role = Fog::Identity::OpenStackCommon::Role.new(options)
          service_mock.expect(:create_role, fake_role_response, [fake_name])

          new_role.save
          service_mock.verify
        end

      end


      describe "#save" do

        describe "with a new role" do

          let(:unsaved_role) { Fog::Identity::OpenStackCommon::Role.new(options) }

          it "creates role" do
            service_mock.expect(:create_role, fake_role_response, [fake_name])

            unsaved_role.save
            service_mock.verify
          end

        end

      end


      describe "#destroy" do

        let(:fake_role) {
          Fog::Identity::OpenStackCommon::Role.new(options.merge!('id' => fake_id))
        }

        it "calls destroy" do
          service_mock.expect(:delete_role, true, [fake_role.id])

          fake_role.destroy
          service_mock.verify
        end

      end

    end
  end
end
