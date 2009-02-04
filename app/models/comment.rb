class Comment < ActiveRecord::Base
  belongs_to :code, :counter_cache => true
  belongs_to :platform
  named_scope :latest, :order => 'created_at desc'
  named_scope :working, :conditions => { :works_for_me => true }
  named_scope :failed, :conditions => { :works_for_me => false }
  delegate :slug_name, :to => :code

  def initialize params = nil
    super
    self.works_for_me ||= true
  end
  
private
  validates_presence_of :code, :platform, :name, :email
  validates_format_of :email, :with => /^([_a-z0-9\+\.\-]+\@[_a-z0-9\-]+\.[_a-z0-9\.\-]+)$/i,
      :unless => Proc.new {|x| x.email.blank? }
end
