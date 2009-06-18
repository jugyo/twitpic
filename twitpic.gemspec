# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{twitpic}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["jugyo"]
  s.date = %q{2009-06-19}
  s.description = %q{Library for TwitPic API.}
  s.email = %q{jugyo.org@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "History.txt"]
  s.files = ["Rakefile", "README.rdoc", "History.txt", "lib/twitpic.rb", "spec/test.txt", "spec/twitpic_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jugyo/twitpic}
  s.rdoc_options = ["--main", "README.rdoc", "--exclude", "spec"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{twitpic}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Library for TwitPic API.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mime-types>, [">= 1.15"])
    else
      s.add_dependency(%q<mime-types>, [">= 1.15"])
    end
  else
    s.add_dependency(%q<mime-types>, [">= 1.15"])
  end
end
