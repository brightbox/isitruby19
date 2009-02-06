gem 'recaptcha'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  # protect_from_forgery # :secret => 'f9bf17028b589db09b49a672a101e6c3'
  filter_parameter_logging :password
  layout 'isitruby19'
  include ReCaptcha::AppHelper
  
protected
  # build an rss feed for the given collection
  # options should be a Hash, giving feed details and mapping the RSS fields to method calls on the contained objects
  # for example: 
  #   rss_for @wotsits, :feed_title => 'My RSS', :feed_link => 'http://somewhere.com', :feed_description => 'stuff about stuff', :title => :title_method, :description => :description_method, :permalink => :permalink_method, :time => :datetime_method
  # the :time method should return a Time object, so the RSS mapper can call #to_s(:rfc822) on it
  # TODO: allow the passing of lambdas so you don't need to add a permalink (view) method to your models
  def rss_for objects, mapping
    RSS::Maker.make("2.0") do | rss | 
      rss.channel.title = mapping[:feed_title]
      rss.channel.link = mapping[:feed_link]
      rss.channel.description = mapping[:feed_description]
      
      objects.each do | object |
        item = rss.items.new_item
        item.title = object.send mapping[:title]
        item.description = object.send mapping[:description]
        item.link = object.send mapping[:permalink]
        item.date = object.send(mapping[:datetime]).to_s(:rfc822)
      end
    end.to_s
  end
end
