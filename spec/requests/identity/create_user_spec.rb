require_relative '../../spec_helper'

require 'fog/openstackcommon'
# require_relative '../../../lib/fog/openstackcommon/models/identity/user'

describe Fog::Identity::OpenStackCommon::Real do

  let(:valid_options) { {
    :provider => 'OpenStackCommon',
    :openstack_auth_url => "http://172.16.0.2:5000/v2.0/tokens",
    :openstack_username => "admin",
    :openstack_api_key => "stack"
    } }

  let(:service) { Fog::Identity.new(valid_options) }

  describe "#create_user" do

    before do
      VCR.insert_cassette 'identity_requests#create_user', :record => :new_episodes
    end

    after do
      VCR.eject_cassette
    end

    it "adds a user" do
      name = "jsmith#{Time.now.to_i}"
      password = "password!"
      tenant_id = "cb7358a6546147a38d13c885626f10f3"
      email = "jsmith#{Time.now.to_i}@acme.com"
      enabled = true

      result = service.create_user(name, password, email, tenant_id, enabled)
      result.status.must_include [200,202]
      # result.body["role"]["id"].must_equal ""
      # result.body["role"]["name"].must_equal ""
    end

  end
end
