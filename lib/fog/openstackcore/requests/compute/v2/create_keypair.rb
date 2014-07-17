module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Create a new keypair
        #
        #
        #
        # ==== Parameters
        # * 'key_name'<~String> - Name of the keypair
        # * 'public_key'<~String> - The public key for the keypair
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'keypair'<~Hash>:
        #       * 'public_key'<~String> - Public portion of the key
        #       * 'name'<~String> - Name of the key
        #       * 'fingerprint' - fingerprint of key value

        def create_keypair(key_name, public_key = nil)
          if public_key.nil?
            data = {
              'keypair' => {
                'name' => key_name
              }
            }
          else
            data = {
              'keypair' => {
                'name'       => key_name,
                'public_key' => public_key
              }
            }
          end

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