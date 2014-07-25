module Fog
  module OpenStackCore
    class BlockStorageV2
      class Real
        # Create a new block storage snapshot
        # The snapshot is created in the same availability_zone as the specified volume
        #
        # ==== Parameters
        # * 'volume_id'<~String>  - UUId of the volume to create the snapshot from
        # * options<~Hash>:
        #   * 'display_name'<~String>        - Name of the snapshot
        #   * 'display_description'<~String> - Description of the snapshot
        #   * 'force'<~Boolean>  - true or false, defaults to false. It allows online snapshots (i.e. when volume is attached)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * snapshot<~Hash>:
        #       * 'id'<~String>: - UUId for the snapshot
        #       * 'display_name'<~String>: - Name of the snapshot
        #       * 'display_description'<~String>: - Description of the snapshot
        #       * 'size'<~Integer>: - Size in GB for the snapshot
        #       * 'status'<~String>: - Status of the snapshot i.e. "available"
        #       * 'volume_id'<~String>: - UUId of the volume from which the snapshot was created
        #       * 'created_at'<~String>: - Timestamp in UTC when volume was created
        #       * metadata<~Hash>: Hash of metadata for the snapshot

        VALID_KEYS = %w{ display_name display_description force metadata volume_id }

        def create_snapshot(volume_id, options={})

          data = {
            'snapshot' => {}
          }

          params = Fog::OpenStackCore::Common.whitelist_keys(options, VALID_KEYS)

          params.each do |key, value|
            data['snapshot'][key] = value
          end

          request(
            :body    => Fog::JSON.encode(data),
            :expects => 200,
            :method  => 'POST',
            :path    => 'snapshots'
          )
        end
      end

      class Mock # :nodoc:all
        ;
      end
    end
  end
end
