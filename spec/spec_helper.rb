require 'minitest/autorun'
require 'minitest/spec'
require 'vcr'
require "minitest-vcr"
require "webmock"
require "minitest/reporters"
require 'simplecov'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.debug_logger = File.open('log/vcr.log', 'w')
end

MinitestVcr::Spec.configure!
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]
SimpleCov.start
