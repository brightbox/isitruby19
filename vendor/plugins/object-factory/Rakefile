require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('object-factory', '0.1.3') do | config | 
  config.description = 'A simple object factory to help you build valid objects in your tests'
  config.url = 'http://github.com/rahoub/object-factory'
  config.author = 'Brightbox Systems Ltd'
  config.email = 'hello@brightbox.co.uk'
  config.ignore_pattern = ['tmp/*', 'script/*']
  config.dependencies = ['rahoulb-rujitsu']
  config.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each do | rake_file | 
  load rake_file
end
