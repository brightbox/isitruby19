class Comment < ActiveRecord::Base
  belongs_to :code, :counter_cache => true
  belongs_to :platform
  named_scope :latest, :order => 'created_at desc'
  named_scope :working, :conditions => { :works_for_me => true }
  named_scope :failed, :conditions => { :works_for_me => false }
  delegate :slug_name, :to => :code

  def initialize params = nil
    super
    self.works_for_me ||= true unless self.works_for_me == false
  end
  
  def platform_name
    platform.name if platform
  end
  
  def code_slug_name
    code.slug_name
  end
  
  def fixed_url
    unless url[%r{^http://}]
      return "http://#{url}"
    else 
      return url
    end
  end
  
  def to_json(options = {})
    default_only = ["body", "name", "url", "works_for_me", "version"]
    options[:only] = (options[:only] || []) + default_only
    options[:include] = {:platform => {:only => :name}}
    super(options)
  end
  
  def to_xml(options = {})
    default_only = ["body", "name", "url", "works_for_me", "version"]
    options[:only] = (options[:only] || []) + default_only
    options[:include] = {:platform => {:only => :name}}
    super(options)
  end
  
private
  validates_presence_of :code, :platform, :name
  validates_format_of :email, :with => /^([_a-z0-9\+\.\-]+\@[_a-z0-9\-]+\.[_a-z0-9\.\-]+)$/i
end
