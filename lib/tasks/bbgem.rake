# Generated with 'brightbox' on Mon Feb 02 16:30:37 +0000 2009
unless Rake::Task.task_defined?("gems:install") 
  def install_gems
gems={
  "ferret" => "~> 0.11",
  "will_paginate" => "> 0"
}
gems.each_pair do |gem, version|
  puts "Checking for #{gem} at #{version}"
  system("gem spec #{gem} --version '#{version}' 2>/dev/null|egrep -q '^name:' ||
          sudo gem install -y --no-ri --no-rdoc --version '#{version}' #{gem}")
end
  end

  def gems_upgrade_notice
puts "This is a dummy task installed by the Brightbox command"
puts "If you need gems to make your application work"
puts "Uncomment the install command and alter the gems on the list"
puts "... or upgrade to Rails >= 2.1 and use the inbuilt facilities"
  end

  namespace(:gems) do
desc "Installs all required gems for this application."
task :install do
  gems_upgrade_notice
  #install_gems 
end
  end
end

unless Rake::Task.task_defined?("db:create") 

  namespace(:db) do
task :create do
  puts "This is a dummy task installed by the Brightbox command"
  puts "Your Rails version is too old to support the db:create task"
  puts "Either upgrade to Rails >=2.0 to use the inbuilt facilities"
  puts "Or create the database by hand if you haven't already"
end
  end
end
unless Rake::Task.task_defined?("db:check:config") 

  def pe(message)
p "#{RAILS_ENV}: #{message}"
  end

  def brightbox_sanity_checks(config)
%w(username password database host).each do |entry|
  pe "#{entry} entry missing" unless config[entry]
end
db=config['database']
host=config['host']
if host && host != 'sqlreadwrite.brightbox.net'
  pe "using '#{host}', not the 'sqlreadwrite.brightbox.net' cluster"
elsif db && db !~ /\A#{config['username']}/
  pe "database name should start with '#{config['username']}' if using cluster"
end
  end
  
require 'yaml'

def read_database_yml
  db_yml = File.join(File.dirname(__FILE__), "..", "..", "config", "database.yml")
  if File.exist?(db_yml)
    return YAML.load(File.open(db_yml))
  else
    return {}
  end
end

namespace(:db) do
  namespace(:check) do
desc "Check database.yml config"
task :config do
  p "Checking database mysql configuration..."
  if config=read_database_yml[RAILS_ENV]
    case config['adapter']
    when nil
      pe "adapter entry missing."
    when 'mysql'
      brightbox_sanity_checks(config)
    else
      pe "using #{config['adapter']} - halting checks"
    end
  else
    pe "section missing."
  end
end
  end
end
  end