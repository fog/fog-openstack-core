module Fog
  module OpenStackCore
    class BlockStorageV2
      class Real
        # Delete an existing block storage volume
        #
        # ==== Parameters
        # * 'volume_id'<~String> - UUId of the volume to delete
        #
        def delete_volume(volume_id)
          response = request(
            :expects => 202,
            :method  => 'DELETE',
            :path    => "volumes/#{volume_id}"
          )
          response
        end
      end

      class Mock # :nodoc:all

      end
    end
  end
end
