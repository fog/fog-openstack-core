module SpecHelpers

  def admin_options_hash
    {
      :openstack_auth_url => "http://devstack.local:5000",
      :openstack_username => "admin",
      :openstack_api_key => "stack",
      :openstack_tenant => "admin",
      :openstack_region => "regionone"#,
      # :connection_options => {:proxy => 'http://localhost:8888'}
    }
  end

  def non_admin_options_hash
    {
      :openstack_auth_url => "http://devstack.local:5000",
      :openstack_username => "demo",
      :openstack_api_key => "stack",
      :openstack_tenant => "demo",
      :openstack_region => "regionone" #,
      # :connection_options => {:proxy => 'http://localhost:8888'}
    }
  end

  def token_options_hash
    {
      :openstack_auth_url => "http://devstack.local:5000",
      :openstack_tenant => "admin",
      :openstack_region => "regionone",
      :openstack_auth_token => nil #,
      # :connection_options => {:proxy => 'http://localhost:8888'}
    }
  end

end
