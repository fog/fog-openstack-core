require 'minitest/autorun'
require 'minitest/spec'
require 'vcr'
require "minitest-vcr"
require "webmock"

VCR.configure do |c|
    c.cassette_library_dir = 'spec/cassettes'
    c.hook_into :webmock
end


MinitestVcr::Spec.configure!
