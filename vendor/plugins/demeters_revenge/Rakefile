require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec/spec_helper'
require 'spec/rake/spectask'

desc 'Default: run all specs.'
task :default => :spec

task :spec => ['spec:all']

namespace :spec do
  
  desc "Run all specs in the spec directory"
  Spec::Rake::SpecTask.new('all') do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts  = %w(--color)
  end
  
  desc "Run all specs in the spec directory in specdox mode"
  Spec::Rake::SpecTask.new('dox') do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts  = %w(--color -f specdoc)
  end
  
  desc "Run functional specs (requires sqlite3)"
  Spec::Rake::SpecTask.new('examples') do |t|
    t.spec_files = FileList['examples/**/*_examples.rb']
    t.spec_opts  = %w(--color)
  end
  
  desc "Start up autotest for specs"
  task :auto do
    require 'spec/spec_autotest'
    RspecAutotest.run
  end  
  
end

desc 'Generate documentation for the demeters_revenge plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'DemetersRevenge'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
