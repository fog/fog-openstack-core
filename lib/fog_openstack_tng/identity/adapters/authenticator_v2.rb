module Fog
  module OpenStack
    module Authentication
      module Adapters
        module AuthenticatorV2
          extend self

          def authenticate(options, connection_options = {})
            uri                   = options[:openstack_auth_uri]
            tenant_name           = options[:openstack_tenant]
            service_type          = options[:openstack_service_type]
            service_name          = options[:openstack_service_name]
            identity_service_type = options[:openstack_identity_service_type]
            endpoint_type         = (options[:openstack_endpoint_type] || 'publicURL').to_s
            openstack_region      = options[:openstack_region]


            body = retrieve_tokens(options, connection_options)

            service = get_service(body, service_type, service_name)

            options[:unscoped_token] = body['access']['token']['id']

            unless service
              unless tenant_name
                response = new_connection(uri, connection_options, body)
                body = Fog::JSON.decode(response.body)
                if body['tenants'].empty?
                  raise Fog::Errors::NotFound.new('No Tenant Found')
                else
                  options[:openstack_tenant] = body['tenants'].first['name']
                end
              end
              body = retrieve_tokens(options, connection_options)
              service = get_service(body, service_type, service_name)
            end

            if openstack_region
              service['endpoints'] = service['endpoints'].select do |endpoint|
                endpoint['region'] == openstack_region
              end
              if service['endpoints'].empty?
                raise Fog::Errors::NotFound.new("No endpoints available for region '#{openstack_region}'")
              end
            end

            unless service
              available = body['access']['serviceCatalog'].map { |endpoint|
                endpoint['type']
              }.sort.join ', '
              missing = service_type.join ', '
              message = "Could not find service #{missing}.  Have #{available}"
              raise Fog::Errors::NotFound, message
            end

            if service['endpoints'].count > 1
              regions = service["endpoints"].map{ |e| e['region'] }.uniq.join(',')
              raise Fog::Errors::NotFound.new("Multiple regions available choose one of these '#{regions}'")
            end

            identity_service = get_service(body, identity_service_type) if identity_service_type
            tenant = body['access']['token']['tenant']
            user = body['access']['user']
            management_url = service['endpoints'].detect{|s| s[endpoint_type]}[endpoint_type]
            identity_url   = identity_service['endpoints'].detect{|s| s['publicURL']}['publicURL'] if identity_service

            return {
              :user                     => user,
              :tenant                   => tenant,
              :identity_public_endpoint => identity_url,
              :server_management_url    => management_url,
              :token                    => body['access']['token']['id'],
              :expires                  => body['access']['token']['expires'],
              :current_user_id          => body['access']['user']['id'],
              :unscoped_token           => options[:unscoped_token]
            }

          end

          private

          def new_connection(uri, connection_options = {}, body = {})
            Fog::Connection.new(
              "#{uri.scheme}://#{uri.host}:#{uri.port}/v2.0/tenants",
              false,
              connection_options).request({
                :expects => [200, 204],
                :headers => {'Content-Type' => 'application/json',
                           'Accept' => 'application/json',
                           'X-Auth-Token' => body['access']['token']['id']},
                :method  => 'GET'
              })
          end

          def get_service(body, service_type=[], service_name=nil)
            body['access']['serviceCatalog'].detect do |s|
              if service_name.nil? or service_name.empty?
                service_type.include?(s['type'])
              else
                service_type.include?(s['type']) and s['name'] == service_name
              end
            end
          end

          def retrieve_tokens(options, connection_options = {})
            api_key     = options[:openstack_api_key].to_s
            username    = options[:openstack_username].to_s
            tenant_name = options[:openstack_tenant].to_s
            auth_token  = options[:openstack_auth_token] || options[:unscoped_token]
            uri         = options[:openstack_auth_uri]

            connection = Fog::Connection.new(uri.to_s, false, connection_options)
            request_body = {:auth => Hash.new}

            if auth_token
              request_body[:auth][:token] = {
                :id => auth_token
              }
            else
              request_body[:auth][:passwordCredentials] = {
                :username => username,
                :password => api_key
              }
            end
            request_body[:auth][:tenantName] = tenant_name if tenant_name

            response = connection.request({
              :expects  => [200, 204],
              :headers  => {'Content-Type' => 'application/json'},
              :body     => Fog::JSON.encode(request_body),
              :method   => 'POST',
              :path     => (uri.path and not uri.path.empty?) ? uri.path : 'v2.0'
            })

            Fog::JSON.decode(response.body)
          end

        end # AuthenticatorV2
      end # Adapters
    end # Authentication
  end # OpenStack
end # Fog