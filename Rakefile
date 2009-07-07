$:.unshift File.dirname(__FILE__) + '/lib'
require 'rubygems'
require 'twitpic'
require 'spec/rake/spectask'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'

name = 'twitpic'
version = TwitPic::VERSION

spec = Gem::Specification.new do |s|
  s.name = name
  s.version = version
  s.summary = "Library for TwitPic API."
  s.description = "Library for TwitPic API."
  s.files = %w(Rakefile README.rdoc History.txt) + Dir.glob("{bin,lib,spec}/**/*")
  s.add_dependency("mime-types", ">= 1.15")
  s.add_dependency("highline", ">= 1.5.1")
  s.add_dependency("rubytter", ">= 0.8.0")
  s.executables = ["twitpic"]
  s.authors = %w(jugyo)
  s.email = 'jugyo.org@gmail.com'
  s.homepage = 'http://github.com/jugyo/twitpic'
  s.rubyforge_project = 'twitpic'
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.rdoc", "--exclude", "spec"]
  s.extra_rdoc_files = ["README.rdoc", "History.txt"]
end

Rake::GemPackageTask.new(spec) do |p|
  p.need_tar = true
end

task :gemspec do
  filename = "#{name}.gemspec"
  open(filename, 'w') do |f|
    f.write spec.to_ruby
  end
  puts <<-EOS
  Successfully generated gemspec
  Name: #{name}
  Version: #{version}
  File: #{filename}
  EOS
end

task :install => [ :package ] do
  sh %{sudo gem install pkg/#{name}-#{version}.gem}
end

task :uninstall => [ :clean ] do
  sh %{sudo gem uninstall #{name}}
end

desc 'run all specs'
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['-c']
end

Rake::RDocTask.new do |t|
  t.rdoc_dir = 'rdoc'
  t.title    = "rest-client, fetch RESTful resources effortlessly"
  t.options << '--line-numbers' << '--inline-source' << '-A cattr_accessor=object'
  t.options << '--charset' << 'utf-8'
  t.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
end

CLEAN.include [ 'pkg', 'rdoc' ]
