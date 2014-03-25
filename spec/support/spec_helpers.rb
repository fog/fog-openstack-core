module SpecHelpers

  def admin_options_hash
    {
      # :provider => 'OpenStackCommon',
      :openstack_auth_url => "http://devstack.local:5000/v2.0/tokens",
      :openstack_username => "admin",
      :openstack_api_key => "stack"
    }
  end

end
