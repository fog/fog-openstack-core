require 'multi_json'
require 'fog/core'

module Fog
  module OpenStackCommon
    module Authentication
      module Adapters
        module AuthenticatorV2


          def self.authenticate(options, connection_options = {})
            # puts "===== Fog::OpenStackCommon::Authentication::Adapters::AuthenticatorV2.authenticate ====="

            # puts "OPTIONS:"
            # puts options.to_yaml
            # puts " "
            # puts "CONNECTION_OPTIONS:"
            # puts connection_options.to_yaml

            uri                   = options[:openstack_auth_uri]
            # puts "URI: #{uri}"

            tenant_name           = options[:openstack_tenant]
            # puts "tenant_name: #{tenant_name}"

            service_type          = options[:openstack_service_type]
            # puts "service_type: #{service_type}"

            service_name          = options[:openstack_service_name]
            # puts "service_name: #{service_name}"

            identity_service_type = options[:openstack_identity_service_type]
            # puts "identity_service_type: #{identity_service_type}"

            endpoint_type         = (options[:openstack_endpoint_type] || 'adminURL').to_s
            # puts "endpoint_type: #{endpoint_type}"

            @openstack_region     = options[:openstack_region]
            # puts "openstack_region: #{openstack_region}"

            body = request_tokens(options, connection_options)

            service = get_service(body, service_type, service_name)

            options[:unscoped_token] = body['access']['token']['id']

            unless service
              unless tenant_name
                options[:openstack_tenant] = get_tenant_name(new_connection(uri, connection_options, body))
              end
              body = request_tokens(options, connection_options)
              service = get_service(body, service_type, service_name)
            end

            if @openstack_region
              service['endpoints'] = get_endpoints(service['endpoints'])
            end

            ensure_service_available(service, body['access']['serviceCatalog'], service_type)

            raise_error_if_multiple_endpoints(service['endpoints'])

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

          def self.new_connection(uri, connection_options = {}, body = {})
            # puts "===== new_connection ====="

            # Fog::Connection.new(
            Fog::Core::Connection.new(
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

          def self.get_service(body, service_type=[], service_name=nil)
            # puts "===== get_service ====="

            body['access']['serviceCatalog'].detect do |s|
              if service_name.nil? or service_name.empty?
                service_type.include?(s['type'])
              else
                service_type.include?(s['type']) and s['name'] == service_name
              end
            end
          end

          def self.get_tenant_name(response)
            body = MultiJson.decode(response.body)
            raise Fog::Errors::NotFound.new('No Tenant Found') if body['tenants'].empty?
            body['tenants'].first['name']
          end

          def self.get_endpoints(endpoints)
            ep = Array(endpoints.select { |endpoint| endpoint['region'] == @openstack_region && endpoint["versionId"] == "2.0"  })
            if ep.empty?
              raise Fog::Errors::NotFound.new("No endpoints available for region '#{@openstack_region}'")
            end
            ep
          end

          def self.ensure_service_available(service, service_catalog, service_type)
            unless service
              available = service_catalog.map { |endpoint| endpoint['type'] }.sort.join ', '
              missing = service_type.join ', '
              raise Fog::Errors::NotFound, "Could not find service #{missing}.  Have #{available}"
            end
          end

          def self.raise_error_if_multiple_endpoints(endpoints)
            if endpoints.count > 1
              regions = endpoints.map{ |e| e['region'] }.uniq.join(',')
              raise Fog::Errors::NotFound.new("Multiple regions available choose one of these '#{regions}'")
            end
          end

          def self.request_tokens(options, connection_options = {})
            # puts "===== request_tokens ====="
            # puts "options:"
            # puts options.to_yaml
            # puts "connection_options:"
            # puts connection_options.to_yaml

            api_key     = options[:openstack_api_key].to_s
            username    = options[:openstack_username].to_s
            tenant_name = options[:openstack_tenant].to_s
            auth_token  = options[:openstack_auth_token] || options[:unscoped_token]
            uri         = options[:openstack_auth_uri]

            # puts "api_key: #{api_key}"
            # puts "username: #{username}"
            # puts "tenant_name: #{tenant_name}"
            # puts "auth_token: #{auth_token}"
            # puts "uri: #{uri}"

            # puts "----- before Connection create -----"
            # connection = Fog::Connection.new(uri.to_s, false, connection_options)
            connection = Fog::Core::Connection.new(uri.to_s, false, connection_options)

            # puts "----- after Connection create -----"
            # puts connection.to_yaml

            request_body = { :auth => Hash.new }

            if auth_token
              # puts "----- if auth_token -----"
              request_body[:auth][:token] = { :id => auth_token }
              # puts "request_body: "
              # puts request_body.to_yaml
            else
              # puts "----- else (!auth_token) -----"
              request_body[:auth][:passwordCredentials] = {
                :username => username,
                :password => api_key
              }
              # puts "request_body: "
              # puts request_body.to_yaml
            end

            request_body[:auth][:tenantName] = tenant_name if tenant_name

            # puts "----- before connection.request -----"
            # puts "request body:"
            # puts request_body.to_yaml
            # puts "request_body encoded:"
            # puts MultiJson.encode(request_body)

            response = connection.request({
              :expects  => [200, 204],
              :headers  => {'Content-Type' => 'application/json'},
              :body     => MultiJson.encode(request_body),
              :method   => 'POST',
              :path     => (uri.path and not uri.path.empty?) ? uri.path : 'v2.0'
            })

            # puts "----- after connection.request -----"
            # puts "response:"
            # puts response.to_yaml

            MultiJson.decode(response.body)
          end

        end # AuthenticatorV2
      end # Adapters
    end # Authentication
  end # OpenStack
end # Fog
