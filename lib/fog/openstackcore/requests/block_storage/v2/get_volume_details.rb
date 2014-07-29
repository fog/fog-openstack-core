module Fog
  module OpenStackCore
    class BlockStorageV2
      class Real
        # Get details for existing block storage volume
        #
        # ==== Parameters
        # * 'volume_id'<~String> - UUId of the volume to get
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * volume<~Hash>:
        #       * 'id'<~String> - UUId for the volume
        #       * 'display_name'<~String> - Name of the volume
        #       * 'display_description'<~String> - Description of the volume
        #       * 'size'<~Integer> - Size in GB for the volume
        #       * 'status'<~String> - Status of the volume i.e. "creating"
        #       * 'volume_type'<~String> - Type of the volume
        #       * 'snapshot_id'<~String> - UUId of the snapshot, the volume was created from.
        #       * 'source_volid'<~String> - UUId of a volume, the volume was created from.
        #       * 'created_at'<~String> - Timestamp in UTC when volume was created
        #       * 'availability_zone'<~String> - Availability zone i.e. "az1"
        #       * attachments<~Array>: Array of hashes of attachments
        #       * metadata<~Hash>: Hash of metadata for the volume

        def get_volume_details(volume_id)
          response = request(
            :expects => [200, 203],
            :method  => 'GET',
            :path    => "volumes/#{volume_id}"
          )
          response
        end

      end

      class Mock

      end
    end
  end
end

