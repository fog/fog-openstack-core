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
      #   * 'keypairs'<~Array>:
      #     * 'keypair'<~Hash>:
      #       * 'public_key'<~String> - Public portion of the key
      #       * 'name'<~String> - Name of the key
      #       * 'fingerprint'<~String> - Fingerprint of the key
      def list_keypairs(options={})
          request(
            :method  => 'GET',
            :expects => 200,
            :path    => "/os-keypairs",
            :query   => options
          )
        end

      end

      class Mock
      end
    end
  end
end
