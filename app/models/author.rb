class Author < ActiveRecord::Base
  
  has_many :authorships
  has_many :codes, :through => :authorships
  
  def permalink
    URL_ROOT + "authors/" + name.to_param
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
  
end
