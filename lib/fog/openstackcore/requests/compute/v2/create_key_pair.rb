module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Create a new keypair
        #
        # ==== Parameters
        # * 'key_name'<~String> - Name of the keypair
        # * 'public_key'<~String> - The public key for the keypair
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'keypair'<~Hash> - The keypair data
        #     * 'public_key'<~String> - The public key for the keypair
        #     * 'private_key'<~String> - The private key for the keypair
        #     * 'user_id'<~String> - The user id
        #     * 'fingerprint'<~String> - SHA-1 digest of DER encoded private key
        #     * 'name'<~String> - Name of key
        def create_key_pair(key_name, public_key = nil)

          data = {
            'keypair' => {
              'name' => key_name
            }
          }

          data['keypair']['public_key'] = public_key unless public_key.nil?

          request(
            :body    => Fog::JSON.encode(data),
            :expects => 200,
            :method  => 'POST',
            :path    => 'os-keypairs'
          )
        end

      end

      class Mock
      end
    end
  end
end

