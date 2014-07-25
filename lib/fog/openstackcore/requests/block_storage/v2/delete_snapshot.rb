module Fog
  module OpenStackCore
    class BlockStorageV2
      class Real
        # Delete an existing block storage snapshot
        #
        # ==== Parameters
        # * 'snapshot_id'<~String> - UUId of the snapshot to delete
        #
        def delete_snapshot(snapshot_id)
          response = request(
            :expects => 202,
            :method  => 'DELETE',
            :path    => "snapshots/#{snapshot_id}"
          )
          response
        end
      end

      class Mock # :nodoc:all

      end
    end
  end
end
