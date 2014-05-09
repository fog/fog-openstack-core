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
  c.default_cassette_options = {
    :match_requests_on => [:method, :path],
    :serialize_with => :json,
    :record => :new_episodes
  }

  c.filter_sensitive_data("http://devstack.local:5000") { ENV['OS_AUTH_URL'] }
  c.filter_sensitive_data("admin") { ENV['OS_ADMIN_USER'] }
  c.filter_sensitive_data("stack") { ENV['OS_ADMIN_API_KEY'] }
  c.filter_sensitive_data("admin") { ENV['OS_ADMIN_TENANT'] }
  c.filter_sensitive_data("admin") { ENV['OS_ADMIN_USER'] }

  c.filter_sensitive_data("demo") { ENV['OS_USER'] }
  c.filter_sensitive_data("stack") { ENV['OS_API_KEY'] }
  c.filter_sensitive_data("demo") { ENV['OS_TENANT'] }
end

MinitestVcr::Spec.configure!
#Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

# VCR.turn_off!(:ignore_cassettes => true)
