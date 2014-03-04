require_relative '../../spec_helper'

require 'fog/openstackcommon'

describe Fog::Identity::OpenStackCommon::Real do

  let(:valid_options) { {
    :provider          => 'OpenStackCommon',
    :openstack_auth_url => "http://devstack.local:5000/v2.0/tokens",
    :openstack_username => "admin",
    :openstack_api_key => "stack"
  } }

  let(:service) { Fog::Identity.new(valid_options) }

  describe "#get_user_by_name", :vcr do

    it "retrieves user information" do

      valid_user_name = service.list_users.body['users'].first["username"]

      result = service.get_user_by_name(valid_user_name)
      result.status.must_equal 200

    end

  end
end
