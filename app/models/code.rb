class Code < ActiveRecord::Base
  
  named_scope :last_thirty_active, :order => "updated_at DESC", :limit => 30
  
  validates_uniqueness_of :name, :slug_name
  validates_presence_of :name, :slug_name
  
  has_many :authorships
  has_many :authors, :through => :authorships
  
  acts_as_ferret :fields => [:name, :description, :homepage, :rubyforge, :github, :slug_name]
  
  before_validation_on_create :set_slug_name
  
  def self.new_from_gem_spec(spec)
    f = find_or_initialize_by_name(spec.name.to_s)
    if f.new_record?
      f.attributes = {:description => spec.description, :homepage => spec.homepage, 
                      :rubyforge => spec.rubyforge_project}
      f.type = "gem"
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
  
  private
  
  def set_slug_name
    self.slug_name = slug_name_from_name || self.rubyforge
  end
  
  include ActiveSupport::Inflector
  def slug_name_from_name
    parameterize(self.name)
  end
  
end
