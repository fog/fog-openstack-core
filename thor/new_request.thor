require 'fog/openstackcore/common'

class NewRequest < Thor::Group
  include Thor::Actions

  argument :service_name
  argument :request_name
  class_option :version, :default => 2


  def self.source_root
    File.dirname(__FILE__)+"/.."
  end

  def new_request
    version = options[:version]
    template('templates/request.tt', "./../lib/fog/openstackcore/requests/#{service_name}/v#{version}/#{request_name}.rb")
    insert_into_file "./../lib/fog/openstackcore/services/#{service_name}_v#{version}.rb", :after => "request_path 'fog/openstackcore/requests/#{service_name}/v#{version}'\n" do
      "\n\t\t\t\trequest :#{request_name}"
    end

  end

  def new_request_test
    version = options[:version]
    template('templates/request_spec.tt', "./../spec/requests#{service_name}/v#{version}/#{request_name}_spec.rb")
  end


end