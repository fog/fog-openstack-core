require_relative '../../spec_helper'

require 'fog/openstackcommon'

describe Fog::Identity::OpenStackCommon::Real do

  let(:valid_options) { {
    :provider => 'OpenStackCommon',
    :openstack_auth_url => "http://devstack.local:5000/v2.0/tokens",
    :openstack_username => "admin",
    :openstack_api_key => "stack"
    } }

  let(:service) { Fog::Identity.new(valid_options) }

  describe "#create_user", :vcr do

    it "creates a user" do
      name = "jsmith#{Time.now.to_i}"
      password = "password!"
      # tenant_id = "e5d888bd17d941eaa4a9a47a674a9d6d"
      tenant_id = "77d49e5184de486ab75500e9fbfed15e"
      email = "jsmith#{Time.now.to_i}@acme.com"
      enabled = true

      result = service.create_user(name, password, email, tenant_id, enabled)
      result.status.must_equal 200
    end

  end
end
