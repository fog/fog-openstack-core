module SpecHelpers

  def admin_options_hash
    {
      :openstack_auth_url => "http://devstack.local:5000",
      :openstack_username => "admin",
      :openstack_api_key => "stack",
      :openstack_tenant => "admin",
      :openstack_region => "regionone"
      # :connection_options => {:proxy => 'http://localhost:8888'}
    }
  end

  def non_admin_options_hash
    {
      :openstack_auth_url => ENV['OS_AUTH_URL'] || "http://devstack.local:5000",
      :openstack_username => ENV['OS_USER'] || "demo",
      :openstack_api_key => ENV['OS_API_KEY'] || "stack",
      :openstack_tenant  => ENV['OS_TENANT'] || "demo",
      :openstack_region  => ENV['OS_REGION'] || "regionone"
    }
  end

  def token_options_hash
    {
      :openstack_auth_url => "http://devstack.local:5000",
      :openstack_tenant => "admin",
      :openstack_region => "regionone",
      :openstack_auth_token => nil
      # :connection_options => {:proxy => 'http://localhost:8888'}
    }
  end

  def non_tenant_options_hash
    {
      :openstack_auth_url => "http://devstack.local:5000",
      :openstack_username => "demo",
      :openstack_api_key => "stack",
      :openstack_region => "regionone"
      # :connection_options => {:proxy => 'http://localhost:8888'}
    }
  end

  def demo_options_hash(proxy = false)
    creds = non_admin_options_hash
    if proxy
      creds.merge!(:connection_options => proxy_options)
    end
    creds
  end

  def proxy_options(host="localhost", port="8888")
    {:proxy => "http://#{host}:#{port}"}
  end

end
