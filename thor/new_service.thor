require 'fog/openstackcore/common'

class NewService < Thor::Group
  include Thor::Actions

  argument :name
  argument :os_service_name_or_type

  class_option :version, :default => 2


  def self.source_root
    File.dirname(__FILE__)+"/.."
  end

  def new_service
    version = options[:version]
    template('templates/service.tt', "./../lib/fog/openstackcore/services/#{name}_v#{version}.rb")
  end

  def new_service_test
    version = options[:version]
    template('templates/service_spec.tt', "./../spec/services/#{name}_v#{version}_service_spec.rb")
  end

  def new_service_proxy
    template('templates/service_proxy.tt', "./../lib/fog/openstackcore/#{name}.rb")
  end

  def new_osc_require
      insert_into_file "./../lib/fog/openstackcore.rb", :after => "require 'fog/openstackcore/common'\n" do
<<REQUIRE

# #{name.upcase}
require 'fog/openstackcore/#{name}'

REQUIRE
      end
  end
end