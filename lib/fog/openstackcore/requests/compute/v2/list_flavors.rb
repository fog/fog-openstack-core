module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List flavors
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'changes-since'<~DateTime> - A time/date stamp for when the image last changed status.
        #   * 'minDisk'<~Integer> - Integer value for the minimum disk space in GB so you can filter results.
        #   * 'minRam'<~Integer> - Integer value for the minimum RAM so you can filter results.
        #   * 'marker'<~UUID> - UUID of the flavor at which you want to set a marker
        #     Only return objects with name greater than this value
        #   * 'limit'<~Integer> - Upper limit to number of results returned
        #     Integer value for the limit of values to return.
        #
        # ==== Returns
        # * flavors<~FlavorsWithOnlyIDsNamesLinks>:
        #   Flavors are known combinations of memory, disk space, and number of CPUs.
        # * 'next'<~UUID> - Moves to the next metadata item.
        # * 'previous'<~UUID> - Moves to the previous metadata item.

        def list_flavors(tenant_id, options={})
          params = Fog::OpenStackCore::Common.whitelist_keys(options,
            %w{changes-since minDisk minRam limit marker})

          request(
            :method   => 'GET',
            :expects  => [200, 203],
            :path     => "/flavors",
            :query    => params
          )
        end

      end

      class Mock
      end
    end
  end
end
