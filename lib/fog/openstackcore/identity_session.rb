require 'fog/openstackcore/service_catalog'

module Fog
  module OpenStackCore
		class IdentitySession
			attr_reader :service_catalog, :current_tenant, :current_user, 
									:token, :unscoped_token, :auth_token

			def initialize(service, access_hash={})
				extract_service_catalog(service, access_hash)
				extract_current_tenant(access_hash['token'])
				extract_current_user(access_hash.delete('user'))
				extract_token(access_hash.delete('token'))
			end

			private

			def extract_service_catalog(service, access_hash={})
				if access_hash['serviceCatalog'].empty?
					@service_catalog = nil
				else					
					@service_catalog = 
						ServiceCatalog.from_response(service, access_hash.delete("serviceCatalog"))
				end
			end

			def extract_current_tenant(token_hash={})
				@current_tenant = token_hash.delete('tenant')
			end

			def extract_current_user(user_hash={})
				@current_user = user_hash
			end

			def extract_token(token_hash={})
				@token = token_hash
				if @current_tenant.nil?
					@unscoped_token = @token['id']
		    	@auth_token = @unscoped_token
				else
		    	@unscoped_token = nil
		    	@auth_token = @token['id']
				end
			end

		end
	end
end