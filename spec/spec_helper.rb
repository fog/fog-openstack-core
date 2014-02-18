# require_relative 'fog_openstack_tng'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'

require File.expand_path './support/vcr_setup.rb', __dir__

MinitestVcr::Spec.configure!
