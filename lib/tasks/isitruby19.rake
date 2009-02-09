namespace :isitruby19 do
  desc "import gems from rubyforge"
  task :import => :environment do
    GemImporter.import
  end

  desc "load the default set of platforms"  
  task :load_platforms => :environment do
    Platform.load_defaults
  end 
  
  desc "Clear expired sessions"
  task :clear_expired_sessions => :environment do
    ActiveRecord::Base.connection.execute("delete from sessions where updated_at < '#{6.hours.ago.to_s(:db)}';")
  end 
end