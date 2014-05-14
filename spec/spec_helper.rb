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
  # c.debug_logger = $stdout
  c.default_cassette_options = { :serialize_with => :json, :record => :new_episodes }
end

MinitestVcr::Spec.configure!
#Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new]

# VCR.turn_off!(:ignore_cassettes => true)
