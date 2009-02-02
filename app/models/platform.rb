class Platform < ActiveRecord::Base
  has_many :comments, :dependent => :destroy

  def to_s
    name
  end

  def self.load_defaults
    add_entry_for 'Mac OSX 10.5'
    add_entry_for 'Mac OSX 10.4'
    add_entry_for 'Solaris'
    add_entry_for 'Ubuntu Intrepid'
    add_entry_for 'Ubuntu Hardy'
    add_entry_for 'Ubuntu Dapper'
    add_entry_for 'Fedora'
    add_entry_for 'Suse'
    add_entry_for 'Debian'
    add_entry_for 'Gentoo'
    add_entry_for 'RHEL'
    add_entry_for 'Windows Vista'
    add_entry_for 'Windows XP'
    add_entry_for 'Windows 7'
  end
  
private

  def self.add_entry_for platform
    create! :name => platform unless Platform.find_by_name(platform)
  end
end
