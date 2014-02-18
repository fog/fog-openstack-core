# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "fog-openstack-tng"
  spec.version       = FogOpenStack::VERSION
  spec.authors       = ["Evan Light", "Kyle Rames", "Chris Johnson", "Mike Hagedorn"]
  spec.email         = ["evan@tripledogdare.net", "kyle.rames@rackspace.com", "wchrisjohnson@gmail.com", "mike.hagedorn@hp.com"]
  spec.summary       = %q{Next generation openstack provider.}
  spec.description   = %q{Next generation openstack provider.}
  spec.homepage      = ""
  spec.license       = "Apache2"

  spec.files         = Dir.glob(File.join("lib", "**", "*.rb"))
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('fog-core')
  # spec.add_dependency('builder')
  # spec.add_dependency('excon', '~>0.31.0')
  # spec.add_dependency('formatador', '~>0.2.0')
  # spec.add_dependency('mime-types')
  spec.add_dependency('net-scp', '~>1.1')
  spec.add_dependency('net-ssh', '>=2.1.3')

  ## List your development dependencies here. Development dependencies are
  ## those that are only needed during development
  spec.add_development_dependency('rake')
  spec.add_development_dependency('minitest')
  # spec.add_development_dependency('yard')
  # spec.add_development_dependency('thor')
  # spec.add_development_dependency('pry')
  # spec.add_development_dependency('coveralls')
end
