require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

describe 'My context' do
   Minitest.after_run do
     self.after_run
   end

  def self.expensive
    @expensive ||= begin
                     puts "only once"
                     "its expensive"
                   end
  end

  def self.after_all
     puts "after run"
  end

  before do
    puts "before test"
  end

  after do
    puts "after test"
  end

  it 'should do something' do
    puts "in test"
    self.class.expensive.must_equal "blah"
  end

  it 'should do something else' do
    puts "in test two"
    self.class.expensive.wont_equal "blah"
  end




end