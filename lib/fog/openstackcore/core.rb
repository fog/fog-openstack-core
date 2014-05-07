require 'fog/openstackcore/errors'
require 'fog/openstackcore/service_discovery'

module Fog
  module OpenStackCore
    extend Fog::Provider
    include Fog::OpenStackCore::Errors

    ServiceDiscovery.register_provider(
      :openstackcore,
      'Fog::OpenStackCore',
      'fog/openstackcore/services')

    service(:identity,      'Identity')
    service(:compute ,      'Compute')
    service(:storage,       'Storage')
    # service(:image,         'Image')
    # service(:network,       'Network')
    # service(:volume,        'Volume')
    # service(:metering,      'Metering')
    # service(:orchestration, 'Orchestration')

  end
end
