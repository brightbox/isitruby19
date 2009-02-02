begin
  require 'rubygems'
  require 'spec'
  
rescue LoadError
  puts "Please install rspec and mocha to run the tests."
  exit 1
end

require File.join(File.dirname(__FILE__), *%w[../lib/demeters_revenge])

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

class ActiveRecordStub
  class << self
    def has_many(name, *args); end
    def has_and_belongs_to_many(name, *args); end
  end
end