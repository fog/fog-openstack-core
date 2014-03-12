require_relative '../../spec_helper'
require 'fog/openstackcommon'

describe "requests" do
  describe "identity" do
    describe "service operations" do

      let(:valid_options) { {
        :provider          => 'OpenStackCommon',
        :openstack_auth_url => "http://devstack.local:5000/v2.0/tokens",
        :openstack_username => "admin",
        :openstack_api_key => "stack"
      } }

      let(:service) { Fog::Identity.new(valid_options) }

      describe "#list_services" do
        it { skip("Choosing to NotImplement for now.") }
      end

      describe "#add_service" do
        it { skip("Choosing to NotImplement for now.") }
      end

      describe "#get_service" do
        it { skip("Choosing to NotImplement for now.") }
      end

      describe "#delete_service" do
        it { skip("Choosing to NotImplement for now.") }
      end

    end
  end
end
