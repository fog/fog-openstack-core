module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List images
        #
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'keypair'<~Hash>:
        #       * 'public_key'<~String> - Public portion of the key
        #       * 'name'<~String> - Name of the key
        #       * 'fingerprint'<~String> - Fingerprint of the key
        # @param [String] keypair_name
        def get_keypair(keypair_name)
          request(
            :method  => 'GET',
            :expects => 200,
            :path    => "/os-keypairs/#{keypair_name}"
          )
        end

      end

      class Mock
      end
    end
  end
end