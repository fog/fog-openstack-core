require 'multi_json'
require 'fog/core'
require 'fog/openstackcommon/errors'

include Fog::OpenStackCommon::Errors

module Fog
  module OpenStackCommon
    extend Fog::Provider

    service(:identity,     'Identity')
    # service(:compute ,      'Compute')
    # service(:image,         'Image')
    # service(:network,       'Network')
    # service(:storage,       'Storage')
    # service(:volume,        'Volume')
    # service(:metering,      'Metering')
    # service(:orchestration, 'Orchestration')

    # def self.authenticate(options, connection_options = {})
    #   discovery_service = Fog::OpenStackCommon::Discovery.new({
    #     :service => 'identity',
    #     :url => 'http://devstack.local:5000'
    #   })
    #   version = discovery_service.version
    #   klass = Module.const_get("Fog::Identity::V#{version}::OpenStackCommon::Real")
    #   klass.new(options.merge!(:connection_options => connection_options))
    # end

  end   # OpenStackCommon
end   # FOG
