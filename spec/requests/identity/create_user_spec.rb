require_relative '../../spec_helper'

require 'fog/openstackcommon'
# require_relative '../../../lib/fog/openstackcommon/models/identity/user'
require ''

describe Fog::Identity::OpenStackCommon::Real do

  let(:valid_options) { {
    :provider => 'OpenStackCommon',
    :openstack_auth_url => "http://172.16.0.2:5000/v2.0/tokens",
    :openstack_username => "admin",
    :openstack_api_key => "stack"
    } }

  let(:service) {Fog::Identity.new(options)}

  describe "#add_user_to_tenant"

    let(:response) {
      {'role' => {
        'id'   => role['id'],
        'name' => role['name']
        }
      }
    }

    tenant_id = "admin"
    user_id = "a956f0ef089244b7935d743481740d77"
    role_id = 200
    result = service.add_user_to_tenant(tenant_id,user_id,role_id)

    result.status.must_equal 200
    result.body["role"]["id"].must_equal ""
    result.body["role"]["name"].must_equal ""

  end
end
