require 'fog/core/collection'
require 'fog/openstackcommon/models/identity/ec2_credential'

module Fog
  module Identity
    class OpenStackCommon
      class Ec2Credentials < Fog::Collection
        model Fog::Identity::OpenStackCommon::Ec2Credentials

        attribute :user

        def all
          return [] unless user
          ec2_credentials = service.list_ec2_credentials(user.id)
          load(ec2_credentials.body['credentials'])
        end

        def create(attributes = {})
          if user then
            attributes[:user_id]   ||= user.id
            attributes[:tenant_id] ||= user.tenant_id
          end
          super attributes
        end

        def destroy(access_key)
          ec2_credential = self.find_by_access_key(access_key)
          ec2_credential.destroy
        end

        def find_by_access_key(access_key)
          find_credential(access_key) || build_credential(access_key)
        end

        private

        def find_credential(access_key)
          self.find { |cred| cred.access == access_key }
        end

        def build_credential(access_key)
          return nil unless user
          response_hash = service.get_ec2_credential(user.id, access_key)
          cred_attribs = response_hash.body['credential']
          Fog::Identity::OpenStackCommon::EC2Credential.new(
            cred_attribs.merge('service' => service))
        end

      end  # Ec2Credentials
    end  # OpenStackCommon
  end  # Identity
end  # Fog
