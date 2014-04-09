require_relative '../spec_helper'

require 'fog/openstackcommon'

describe "services" do
  describe "identity_v2" do

    let(:credentials_tenant_hash) {
      {
        :openstack_auth_url => "http://devstack.local:5000",
        :openstack_username => "admin",
        :openstack_api_key => "stack",
        :openstack_tenant => "admin",
        :openstack_region => "regionone"
      }
    }

    describe "#initialize" do

      describe "#auth_with_credentials_and_tenant" do

        describe "with valid credentials", :vcr do

          let(:service) { Fog::OpenStackCommon::ComputeV2.new(credentials_tenant_hash) }

          it "returns a service reference" do
            service.must_be_instance_of Fog::OpenStackCommon::ComputeV2::Real
          end

          # [ :service_catalog, :token, :auth_token, :unscoped_token,
          #   :current_tenant, :current_user ].each do |attrib|
          #   it { service.must_respond_to attrib }
          # end

        end   # with valid credentials

      end  #auth_with_credentials_and_tenant

    end # initialize

  end # compute
end # services
