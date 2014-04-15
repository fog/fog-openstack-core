require 'fog/OpenStackCore/errors'

module Fog
  module OpenStackCore
    extend Fog::Provider
    include Fog::OpenStackCore::Errors

    service(:identity,     'Identity')
    # service(:compute ,      'Compute')
    # service(:image,         'Image')
    # service(:network,       'Network')
    # service(:storage,       'Storage')
    # service(:volume,        'Volume')
    # service(:metering,      'Metering')
    # service(:orchestration, 'Orchestration')

  end   # OpenStackCore
end   # FOG
