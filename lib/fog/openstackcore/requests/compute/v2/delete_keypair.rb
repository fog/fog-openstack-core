module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # Delete a keypair
        #
        #
        #
        # Delete a keypair
        #
        # ==== Parameters
        # * 'key_name'<~String> - Name of the keypair to delete
        #
        def delete_keypair(key_name)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :path    => "os-keypairs/#{key_name}"
          )
        end

      end

  class Mock
  end
end
end
end