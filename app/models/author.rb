class Author < ActiveRecord::Base
  
  has_many :authorships
  has_many :codes, :through => :authorships

end
