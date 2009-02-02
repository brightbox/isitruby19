namespace :isitruby19 do
  desc "import gems from rubyforge"
  task :import => :environment do
    GemImporter.import
  end
end