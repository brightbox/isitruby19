class Code < ActiveRecord::Base
  has_many :authorships
  has_many :authors, :through => :authorships
  has_many :comments, :dependent => :destroy, :order => 'created_at desc'
  has_many :working_comments, :class_name => 'Comment', :conditions => { :works_for_me => true }
  has_many :failure_comments, :class_name => 'Comment', :conditions => { :works_for_me => false }

  named_scope :popular, :order => 'comments_count desc'
  named_scope :unpopular, :order => 'comments_count asc'
  
  def code_slug_name
    self.slug_name
  end
  
  def permalink
    URL_ROOT + code_slug_name
  end
  
  def works?
    has_no_failure_comments? && has_working_comments?
  end
  
  def has_homepage_url?
    self.homepage =~ /^http:/i
  end
  
  def description_or_summary
    return description unless description.blank?
    return summary
  end
  
  def to_json(options = {})
    default_only = ["name", "description", "summary", "homepage", "rubyforge", "code_type"]
    options[:only] = (options[:only] || []) + default_only
    options[:methods] = :permalink
    super(options)
  end
  
  def to_xml(options = {})
    default_only = ["name", "description", "summary", "homepage", "rubyforge", "code_type"]
    options[:only] = (options[:only] || []) + default_only
    super(options)  do |xml|
      xml.permalink permalink
    end
  end
    
  def self.new_from_gem_spec(spec)
    f = find_or_initialize_by_name(spec.name.to_s)
    if f.new_record?
      f.attributes = {:description => spec.description, :homepage => spec.homepage, :rubyforge => spec.rubyforge_project, :summary => spec.summary}
      f.code_type = "gem"
      f.save!
      spec.authors.each do |author|
        a = Author.find_or_create_by_name(author)
        f.authors << a
      end
      logger.info("Imported Gem: #{f.name}")
    else
      logger.info("Gem #{spec.name} already existed")
    end
  rescue => e
    logger.info("Could not create code from gem spec\n #{spec.inspect}")
  end
  
  def self.compatibility
    total = Comment.count
    total = 1 if total == 0
    Comment.working.size * 100 / total
  end
  
private
  
  validates_uniqueness_of :name, :slug_name
  validates_presence_of :name, :slug_name
  
  before_validation_on_create :set_slug_name
  
  acts_as_ferret :fields => [:name, :description, :homepage, :rubyforge, :github, :slug_name, :summary]
  
  def set_slug_name
    self.slug_name = slug_name_from_name || self.rubyforge
  end
  
  include ActiveSupport::Inflector
  def slug_name_from_name
    parameterize(self.name)
  end
  
end
