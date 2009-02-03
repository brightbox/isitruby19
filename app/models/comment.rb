class Comment < ActiveRecord::Base
  belongs_to :code, :counter_cache => true
  belongs_to :platform
  named_scope :latest, :order => 'created_at desc'
  named_scope :working, :conditions => { :works_for_me => true }
  named_scope :failed, :conditions => { :works_for_me => false }
  
private
  validates_presence_of :code
  validates_presence_of :platform
end
