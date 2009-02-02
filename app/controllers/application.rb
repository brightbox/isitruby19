# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # :secret => 'f9bf17028b589db09b49a672a101e6c3'
  filter_parameter_logging :password
  layout 'isitruby19'
end
