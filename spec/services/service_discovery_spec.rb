require 'spec_helper'

require 'fog/openstackcore/service_discovery'

describe Fog::OpenStackCore::ServiceDiscovery do
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
    it 'instantiates the necessary OSC service (strings)' do
      s = Fog::OpenStackCore::ServiceDiscovery.new('openstackcore', 'foobar', :version => 1).call
      assert_instance_of Fog::OpenStackCore::FoobarV1, s
    end

    it 'instantiates the necessary OSC service (symbols)' do
      s = Fog::OpenStackCore::ServiceDiscovery.new(:openstackcore, :foobar, :version => 1).call
      assert_instance_of Fog::OpenStackCore::FoobarV1, s
    end

    describe 'when attempting to load a class not in a service_path' do
      it 'receives a LoadError' do
        assert_raises(LoadError) do
          Fog::OpenStackCore::ServiceDiscovery.new('openstackcore','foobar', :version => 2).call
        end
      end

      it 'cites the searched for file name and current paths in the LoadError' do
        begin
          Fog::OpenStackCore::ServiceDiscovery.new('openstackcore', 'foobar', :version => 2).call
        rescue LoadError => e
          assert_includes(e.message, 'foobar_v2')
          assert_includes(e.message, 'fog/openstackcore/services')
        end
      end
    end

    describe 'when loading a class present in a service_path' do
      it 'requires files listed in its service_path' do
        Fog::OpenStackCore::ServiceDiscovery.register_provider('fixture', 'Fog::FakeProvider', 'fixtures/fog/fakeprovider/services')
        s = Fog::OpenStackCore::ServiceDiscovery.new('fixture', 'foobar', :version => 2).call
        assert_instance_of Fog::FakeProvider::FoobarV2, s
        Fog::OpenStackCore::ServiceDiscovery.unregister_provider('fixture')
      end
    end
  end
end
