require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'spec'
  t.pattern = 'spec/**/*_spec.rb'
  t.warning = true
  t.verbose = true
end

task(default: :test)

desc 'Generates a coverage report'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].execute
end

desc 'Runs compute tasks'
task :compute do
  $LOAD_PATH.unshift('lib', 'spec')
  Dir.glob('./spec/**/compute/**/*_spec.rb') { |f| require f }
end

namespace :test do
  desc 'Run subset of tests, rake test:sub[compute|storage]'
  task :sub,:section do |t,args|
    section = args[:section]
    $LOAD_PATH.unshift('lib', 'spec')
    Dir.glob("./spec/**/#{section}/**/*_spec.rb") { |f| require f }
  end
end

namespace :vcr do
  desc "list the cassettes, rake vcr:reset[compute|storage| ...]"
  task :list,:section do |t,args|
    section = args[:section]
    Dir.glob("./spec/cassettes/**/#{section}**/**/*.json") { |f| puts f }
  end

  desc "delete the cassettes, rake vcr:reset[compute|identity|...]"
  task :reset, :section do |t, args|
    section = args[:section]
    FileUtils.rm(Dir.glob("./spec/cassettes/**/#{section}**/**/*.json"))
  end
end

