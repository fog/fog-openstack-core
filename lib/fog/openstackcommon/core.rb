require 'multi_json'
require 'fog/core'
require 'fog/openstackcommon/discovery'
require 'fog/openstackcommon/errors'

include Fog::OpenStackCommon::Errors

module Fog
  module OpenStackCommon
    extend Fog::Provider

    service(:identity_v2,      'Identity')
#     service(:compute ,      'Compute')
#     service(:image,         'Image')
#     service(:network,       'Network')
#     service(:storage,       'Storage')
#     service(:volume,        'Volume')
#     service(:metering,      'Metering')
#     service(:orchestration, 'Orchestration')

    def self.authenticate(options, connection_options = {})
      # Fog::Identity.new(options, connection_options = {})
      version = Discovery.locate(
        :service => 'identity', :url => 'http://devstack.local:5000'
      )
      klass = Module.const_get("Fog::Identity::V#{version}")
      klass.new(options, connection_options)
    end

  end   # OpenStackCommon
end   # FOG
