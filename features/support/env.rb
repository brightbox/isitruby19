# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
Cucumber::Rails.use_transactional_fixtures
require 'cucumber/rails/rspec'
require 'webrat/rails'
require 'object_factory'
require 'lib/object_factory_config'
require 'mocha'

prepare_object_factory

#`rm log/selenium.log`

Webrat.configure do | config | 
  config.mode = :rails
  #config.mode = :selenium
end

Before do
  ActionMailer::Base.deliveries.clear
end