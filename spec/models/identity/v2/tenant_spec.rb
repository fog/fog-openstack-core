require_relative '../../../spec_helper'

require 'fog/openstackcore'
require 'fog/openstackcore/models/identity/v2/tenant'

require 'ostruct'

describe "models" do
  describe "identity_v2" do
    describe "tenant" do

      let(:service_mock) { Minitest::Mock.new }

      let(:fake_id) { "tenant123" }
      let(:fake_name) { "MyTenant-#{Time.now.to_i}" }
      let(:fake_description) { "MyTenantDescription" }
      let(:fake_enabled) { true }

      let(:options) {
        { :service => service_mock,
          :name => fake_name,
          :description => fake_description,
          :enabled => fake_enabled
        }
      }

      let(:fake_tenant) {
        Fog::OpenStackCore::IdentityV2::Tenant.new(options.merge!('id' => fake_id))
      }

      let(:fake_tenant_response) {
        response = OpenStruct.new
        response.body = {'tenant' => {}}
        response
      }

      before do
        # have to do this to handle fog-core check
        service_mock.expect(:nil?, false, [])
      end

      describe "new tenant" do

        it "throws exception when name is missing" do
          proc {
            options.delete(:name)
            new_tenant = Fog::OpenStackCore::IdentityV2::Tenant.new(options)
            options.delete(:service)
            service_mock.expect(:create_tenant, fake_tenant_response, [options])

            new_tenant.save
            service_mock.verify
          }.must_raise ArgumentError
        end

        it "creates tenant when name is specified" do
          new_tenant = Fog::OpenStackCore::IdentityV2::Tenant.new(options)
          options.delete(:service)
          service_mock.expect(:create_tenant, fake_tenant_response, [options])

          new_tenant.save
          service_mock.verify
        end

      end # new tenant


      describe "existing tenant" do

        describe "update" do

          let(:expected_options) { options.clone }

          it "name" do
            expected_options.delete(:service)
            expected_options.merge!(:name => 'new-name')
            expected_options.merge!(:id => fake_id)

            service_mock.expect(
              :update_tenant,
              fake_tenant_response,
              [fake_tenant.id, expected_options]
            )

            fake_tenant.name = expected_options[:name]
            fake_tenant.save
            service_mock.verify
          end

          it "description" do
            expected_options.delete(:service)
            expected_options.merge!(:description => 'test123')
            expected_options.merge!(:id => fake_id)

            service_mock.expect(
              :update_tenant,
              fake_tenant_response,
              [fake_tenant.id, expected_options]
            )

            fake_tenant.description = expected_options[:description]
            fake_tenant.save
            service_mock.verify
          end

          it "enabled" do
            expected_options.delete(:service)
            expected_options.merge!(:enabled => false)
            expected_options.merge!(:id => fake_id)

            service_mock.expect(
              :update_tenant,
              fake_tenant_response,
              [fake_tenant.id, expected_options]
            )

            fake_tenant.enabled = expected_options[:enabled]
            fake_tenant.save
            service_mock.verify
          end

        end # update

        describe "#destroy" do

          it "calls destroy" do
            service_mock.expect(:delete_tenant, true, [fake_tenant.id])

            fake_tenant.destroy
            service_mock.verify
          end

        end  #destroy


        describe "#users" do

          it "calls users" do
            service_mock.expect(:users, {}, [{:tenant_id => fake_tenant.id}])

            fake_tenant.users
            service_mock.verify
          end

        end #users


        describe "#to_s" do

          it "returns name" do
            fake_tenant.to_s.must_equal fake_name
          end

        end #to_s

      end # update

    end
  end
end
