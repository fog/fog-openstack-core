require 'fog/openstackcommon'

options = {
    :provider          => 'OpenStackCommon',
    :openstack_auth_url => "http://devstack.local:5000",
    :openstack_username => "admin",
    :openstack_api_key => "stack"
}

x = Fog::OpenStackCommon::Identity.new(options)