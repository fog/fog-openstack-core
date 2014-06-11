module SpecHelpers


  def admin_options_hash()
    {
      :openstack_auth_url => ENV['OS_AUTH_URL'] || "http://15.126.201.211:5000",
      :openstack_username => ENV['OS_ADMIN_USER'] || "admin",
      :openstack_api_key => ENV['OS_ADMIN_API_KEY'] || "stack",
      :openstack_tenant =>  ENV['OS_ADMIN_TENANT'] || "admin",
      :openstack_region => ENV['OS_REGION'] || "RegionOne",
      :connection_options => {:proxy => 'http://localhost:8888'}
    }
  end



  def non_admin_options_hash
    {
      :openstack_auth_url => ENV['OS_AUTH_URL'] || "http://15.126.201.211:5000",
      :openstack_username => ENV['OS_USER'] || "demo",
      :openstack_api_key => ENV['OS_API_KEY'] || "stack",
      :openstack_tenant =>  ENV['OS_TENANT'] || "demo",
      :openstack_region => ENV['OS_REGION'] || "RegionOne",
      :connection_options => {:proxy => 'http://localhost:8888'}
    }
  end

  def token_options_hash
    {
      :openstack_auth_url => ENV['OS_AUTH_URL'] || "http://15.126.201.211:5000",
      :openstack_tenant =>  ENV['OS_ADMIN_TENANT'] || "admin",
      :openstack_region => ENV['OS_REGION'] || "RegionOne",
      :openstack_auth_token => nil
      # :connection_options => {:proxy => 'http://localhost:8888'}
    }
  end

  def non_tenant_options_hash
    {
      :openstack_auth_url => ENV['OS_AUTH_URL'] ||"http://15.126.201.211:5000",
      :openstack_username => ENV['OS_USER'] || "demo",
      :openstack_api_key => ENV['OS_API_KEY'] || "stack",
      :openstack_region => ENV['OS_REGION'] || "RegionOne"
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

  def compute_v2_service(proxy = false)
    @service ||= Fog::OpenStackCore::ComputeV2.new(demo_options_hash(proxy))
  end

  def first_user_with_tenant_id(user_list_response)
    user_list_response.body['users'].each do |user_hash|
      if user_hash['tenantId']
        return user_hash
      end
    end
  end

end
