class Comment < ActiveRecord::Base
  belongs_to :code
  belongs_to :platform
  
private
  validates_presence_of :code
  validates_presence_of :platform
end
