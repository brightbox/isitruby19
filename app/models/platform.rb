class Platform < ActiveRecord::Base
  has_many :comments, :dependent => :destroy

  def to_s
    name
  end

  def self.load_defaults
    add_entry_for 'Mac OSX'
    add_entry_for 'GNU/Linux'
    add_entry_for 'Windows'
    add_entry_for 'Solaris'
    add_entry_for 'other'
  end
  
private

  def self.add_entry_for platform
    create! :name => platform unless Platform.find_by_name(platform)
  end
end
