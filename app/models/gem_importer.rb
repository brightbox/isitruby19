require 'rubygems'
require "rubygems/source_info_cache"
class GemImporter
  
  def self.import
    a = Gem::SourceInfoCache.new
    puts "instantiated"
    a.refresh(true) #seems to want an argument but never uses it...
    a.cache_data["http://gems.rubyforge.org/"].source_index.each do |gem_name, gem|
      Code.new_from_gem_spec(gem)
    end
    puts "done"
  rescue Exception => ex
    puts ex.message
  end
  
end