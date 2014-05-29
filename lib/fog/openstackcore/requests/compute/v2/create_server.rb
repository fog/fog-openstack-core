module Fog
  module OpenStackCore
    class ComputeV2
      class Real

        # List existing servers
        #
        # ==== Normal Response Codes
        #   * 202
        #
        # ==== Error Response Codes
        #   * computeFault (400, 500, …)
        #   * UnprocessableEntity (422)
        #   * serviceUnavailable (503)
        #   * badRequest (400)
        #   * unauthorized (401)
        #   * forbidden (403)
        #   * badMethod (405)
        #   * overLimit (413)
        #   * itemNotFound (404)
        #   * badMediaType (415)
        #   * NetworkNotFound (400)
        #   * serverCapacityUnavailable (503)
        #

        # ==== Parameters
        # * 'server'<~ServerForCreate> - server
        # * 'imageRef'<~String> - The image reference for the desired image
        #   for your server instance. Specify as an ID or full URL.
        # * 'flavorRef'<~String> - The flavor reference for the desired flavor
        #   for your server instance. Specify as an ID or full URL.
        # * 'name'<~String> - The server name.
        # * options<~Hash>:
        #   * 'security_groups'<~String> - security_groups object.
        #   * 'security_group'<~String> - One or more security_group objects.
        #     Specify the name of the security group in the name attribute. If
        #     you omit this attribute, the server is created in the default
        #     security group.
        #   * 'user_data'<~String> - Configuration information or scripts to use
        #     upon launch. Must be Base64 encoded.
        #   * 'availability_zone'<~String> - The availability zone in which to
        #     launch the server.
        #   * 'networks'<~String> - A networks object. By default, the server
        #     instance is provisioned with all isolated networks for the tenant.
        #     Optionally, you can create one or more NICs on the server. To
        #     provision the server instance with a NIC for a nova-network
        #     network, specify the UUID in the uuid attribute in a networks
        #     object. To provision the server instance with a NIC for a neutron
        #     network, specify the UUID in the port attribute in a networks
        #     object. You can specify multiple NICs on the server.
        #   * 'uuid'<~String> - To provision the server instance with a NIC for
        #     a nova-network network, specify the UUID in the uuid attribute in
        #     a networks object. Required if you omit the port attribute.
        #   * 'port'<~String> - To provision the server instance with a NIC for
        #     a neutron network, specify the UUID in the port attribute in a
        #     networks object. Required if you omit the uuid attribute.
        #   * 'fixed_ip'<~String> - A fixed IPv4 address for the NIC. Valid with
        #     a neutron or nova-networks network.
        #   * 'metadata'<~String> - Metadata key and value pairs. The maximum
        #     size of the metadata key and value is 255 bytes each.
        #   * 'personality'<~String> - File path and contents (text only) to
        #     inject into the server at launch. The maximum size of the file
        #     path data is 255 bytes. The maximum limit refers to the number of
        #     bytes in the decoded data and not the number of characters in the
        #     encoded data.
        #
        # ==== Returns

        # changes-since (Optional)	query	xsd:dateTime
        # A time/date stamp for when the server last changed status.
        #
        # image (Optional)	query	xsd:anyURI
        # Name of the image in URL format.
        #
        # flavor (Optional)	query	xsd:anyURI
        # Name of the flavor in URL format.
        #
        # name (Optional)	query	xsd:string
        # Name of the server as a string.
        #
        # marker (Optional)	query	csapi:UUID
        # UUID of the server at which you want to set a marker.
        #
        # limit (Optional)	query	xsd:int
        # Integer value for the limit of values to return.
        #
        # status (Optional)	query	csapi:ServerStatus
        # Value of the status of the server so that you can filter on "ACTIVE" for example.
        #
        # host (Optional)	query	xsd:string
        # Name of the host as a string.

        VALID_KEYS = %w{security_groups security_group user_data
          availability_zone server networks uuid port fixed_ip metadata
          personality}

        def create_server(name, flavor_ref, image_ref, options = {})

          params = Fog::OpenStackCore::Common.whitelist_keys(options, VALID_KEYS)

          # build payload hash
          data = {
            'server' => {
              'name'       => "#{name}",
              'flavorRef'  => "#{flavor_ref}",
              'imageRef'   => "#{image_ref}"
            }
          }

          # assign security_groups on create if necessary
          security_groups = options.delete('security_groups')
          if security_groups
            data['server']['security_groups'] = []
            options['security_groups'].each do |sg|
              data['server']['security_groups'] << {
                'name' => sg
              }
            end
          end

          # add capability to specify a network id while creating a server
          networks = options.delete('networks')
          if networks
            data['server']['networks'] = []
            options['networks'].each do |net_id|
              data['server']['networks'] << {
                'uuid' => net_id
              }
            end
          end

          # post create script(s) to run
          personality = options.delete('personality')
          if personality
            data['server']['personality'] = []
            options['personality'].each do |file|
              data['server']['personality'] << {
                'contents'  => Base64.encode64(file['contents']),
                'path'      => file['path']
              }
            end
          end

          # pick up any options not explicitly handled
          options.select{|o| options[o]}.each do |key|
            data['server'][key] = options[key]
          end

          request(
            :method   => 'POST',
            :expects  => [202],
            :path     => "/servers",
            :body     => MultiJson.encode(data)
          )
        end

      end

      class Mock
      end
    end
  end
end
