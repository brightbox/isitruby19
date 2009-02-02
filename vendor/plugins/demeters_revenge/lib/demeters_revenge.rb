unless defined?(RAILS_ROOT)
  require 'rubygems'
  require 'active_support'
end

module DemetersRevenge
  
  module VERSION
    MAJOR = 0
    MINOR = 1
    TINY  = nil
    
    def self.to_s
      [MAJOR, MINOR, TINY].compact.map(&:to_i).join('.')
    end
  end
  
  class MultipleTransmogrification < RuntimeError; end
end

Dir[File.join(File.dirname(__FILE__), "demeters_revenge/**/*.rb")].each do |lib|
  require lib
end