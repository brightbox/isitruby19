gem 'recaptcha'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # :secret => 'f9bf17028b589db09b49a672a101e6c3'
  filter_parameter_logging :password
  layout 'isitruby19'
  include ReCaptcha::AppHelper
end
