require 'fog/openstackcommon/errors'

module Fog
  module OpenStackCommon
    extend Fog::Provider
    include Fog::OpenStackCommon::Errors

    service(:identity,       'Identity')
    service(:compute ,       'Compute')
    # service(:image,          'Image')
    # service(:network,        'Network')
    # service(:storage,        'Storage')
    # service(:volume,         'Volume')
    # service(:metering,       'Metering')
    # service(:orchestration,  'Orchestration')

  end   # OpenStackCommon
end   # FOG
