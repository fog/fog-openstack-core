require 'minitest/autorun'
require 'minitest/spec'
require 'vcr'
require "minitest-vcr"
require "webmock"
require "minitest/reporters"

VCR.configure do |c|
    c.cassette_library_dir = 'spec/cassettes'
    c.hook_into :webmock
end

MinitestVcr::Spec.configure!
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]
