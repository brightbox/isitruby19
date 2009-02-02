namespace :isitruby19 do
  desc "import gems from rubyforge"
  task :import => :environment do
    GemImporter.import
  end

  desc "load the default set of platforms"  
  task :load_platforms => :environment do
    Platform.load_defaults
  end 
end