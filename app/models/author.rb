class Author < ActiveRecord::Base
  
  has_many :authorships
  has_many :codes, :through => :authorships
  
  def permalink
    URL_ROOT + "authors/" + self.slug_name
  end
  
  def to_json(options = {})
    default_only = ["name"]
    options[:only] = (options[:only] || []) + default_only
    options[:include] = [:codes]
    options[:methods] = :permalink
    super(options)
  end
  
  def to_xml(options = {})
    default_only = ["name"]
    options[:only] = (options[:only] || []) + default_only
    options[:include] = [:codes]
    super(options) do |xml|
      xml.permalink permalink
    end
  end
  
  def self.update_all_slug_names
    find(:all).each {|x| x.update_slug_name }
  end
    
  def update_slug_name
    update_attribute(:slug_name, ActiveSupport::Inflector.parameterize(self.name)) unless self.name.blank?
  end
  
end
