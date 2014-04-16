require 'spec_helper'

require 'fog/openstackcore/service_discovery'

$LOAD_PATH << 'spec/fixtures'

describe Fog::OpenStackCore::ServiceDiscovery do
  describe '::register_service' do
    it 'errors when given a class not in Fog::OpenStackCore' do
      assert_raises(Fog::OpenStackCore::ServiceError) do
        Fog::OpenStackCore::ServiceDiscovery.register_service(String)
      end
    end

    it 'accepts classes in Fog::OpenStackCore' do
      Fog::OpenStackCore::ServiceDiscovery.register_service(Fog::OpenStackCore::Identity)
    end

    it 'includes registered classes' do
      Fog::OpenStackCore::ServiceDiscovery.register_service(Fog::OpenStackCore::Identity)
      assert(Fog::OpenStackCore::ServiceDiscovery.valid_services['identity'])
    end
  end

  describe '::register_service_path' do
    it 'makes non-OpenStackCore classes available for discovery'
  end

  describe '::new' do
    it 'errors out when given an invalid service' do
      assert_raises(Fog::OpenStackCore::ServiceError) do
        Fog::OpenStackCore::ServiceDiscovery.new('foobar')
      end
    end
  end

  module Fog
    module OpenStackCore
      class Foobar
      end

      class FoobarV1
        def initialize(opts); end
      end
    end
  end

  describe '#call' do
    before do
      Fog::OpenStackCore::ServiceDiscovery.register_service(Fog::OpenStackCore::Foobar)
    end

    it 'instantiates the necessary OSC service' do
      Fog::OpenStackCore::ServiceDiscovery.new('foobar', :version => 1).call
    end

    it 'loads the class for the service if it has not already been loaded' do
      # Loads the fixture FoobarV2 class
      Fog::OpenStackCore::ServiceDiscovery.new('foobar', :version => 2).call
    end
  end
end






