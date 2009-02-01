class User < ActiveRecord::Base
  acts_as_authentic
  
  attr_protected :is_admin
  
end
