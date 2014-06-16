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

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  #c.debug_logger = $stdout
  c.default_cassette_options = { :serialize_with => :json, :match_requests_on => [:method, :uri, :body ], :record => :new_episodes }
end

MinitestVcr::Spec.configure!
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

# VCR.turn_off!(:ignore_cassettes => true)

class TestContext
 class << self
   #@param server_builder proc which
   def nova_server(reset = false)
      if reset
        @nova_server = yield
        return @nova_server
      end
      return @nova_server if @nova_server
      @nova_server =  yield
   end

   def reset_context
     @nova_server = nil
   end


 end
end
