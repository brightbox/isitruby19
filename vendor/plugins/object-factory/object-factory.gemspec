# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{object-factory}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brightbox Systems Ltd"]
  s.date = %q{2008-12-08}
  s.description = %q{A simple object factory to help you build valid objects in your tests}
  s.email = %q{hello@brightbox.co.uk}
  s.extra_rdoc_files = ["CHANGELOG", "lib/object_factory.rb", "README.rdoc", "tasks/rspec.rake"]
  s.files = ["CHANGELOG", "init.rb", "lib/object_factory.rb", "Manifest", "object-factory.gemspec", "Rakefile", "README.rdoc", "spec/object_spec.rb", "spec/spec.opts", "tasks/rspec.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/rahoub/object-factory}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Object-factory", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{object-factory}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A simple object factory to help you build valid objects in your tests}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rahoulb-rujitsu>, [">= 0"])
    else
      s.add_dependency(%q<rahoulb-rujitsu>, [">= 0"])
    end
  else
    s.add_dependency(%q<rahoulb-rujitsu>, [">= 0"])
  end
end
