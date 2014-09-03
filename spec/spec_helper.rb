require 'fog/openstackcore'

require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/reporters'
require 'minitest-vcr'
require 'webmock'
require 'vcr'

Excon.defaults[:ssl_verify_peer] = false

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  #c.debug_logger = $stdout
  c.default_cassette_options = { :serialize_with => :json, :record => :new_episodes}
end

MinitestVcr::Spec.configure!
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

# VCR.turn_off!(:ignore_cassettes => true)

HOSTNAME     = `hostname`.chomp
RANDOM_CHARS = [('a'..'z')].map { |i| i.to_a }.flatten

class TestContext
  class << self
    #@param server_builder proc which
    def nova_server(reset = false)
      if reset
        @nova_server = yield
        return @nova_server
      end
      return @nova_server if @nova_server
      @nova_server = yield
    end

    def service
      return @service if @service
      @service = yield
    end

    def reset_context
      @nova_server = nil
    end



  end
end

def wait_for_server(service, server)
  #loop until ready
  begin
    tries = 7
    begin
      if  service.get_server_details(server).body["server"]["status"] == "ACTIVE"
        puts "Server is UP!"
      else
        raise "Server Not Active Yet"
      end
    rescue Exception => e
      tries -= 1
      puts "Server Not Ready"
      if tries > 0
        sleep(10)
        retry
      else
        exit(1)
      end
    end
  end
end

def locate_bootable_image(service)
  images = service.list_images
  image_filtered = images.body["images"].collect { |img| [img["id"], img["name"]] }
  image_id       = image_filtered.select { |img| img[1] =~ /\Acirros/ }.first[0]
end

# Generate a unique resource name
def resource_name(seed=random_string(5))
  'fog_' << HOSTNAME << '_' << Time.now.to_i.to_s << '_' << seed.to_s
end

