require 'multi_json'
require 'fog/core'
require 'fog/openstackcommon/errors'

include Fog::OpenStackCommon::Errors

module Fog
  module OpenStackCommon
    extend Fog::Provider
    extend self

    service(:identity,      'Identity')
#     service(:compute ,      'Compute')
#     service(:image,         'Image')
#     service(:network,       'Network')
#     service(:storage,       'Storage')
#     service(:volume,        'Volume')
#     service(:metering,      'Metering')
#     service(:orchestration, 'Orchestration')

    def authenticate(options, connection_options = {})
      Fog::Identity.new(options, connection_options = {})
    end

  end   # OpenStackCommon
end   # FOG
