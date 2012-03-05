# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "bio-alignment"
  gem.homepage = "http://github.com/pjotrp/bioruby-alignment"
  gem.license = "MIT"
  gem.summary = %Q{Support for multiple sequence alignments (MSA)}
  gem.description = %Q{Alignment handler for multiple sequence alignments (MSA)}
  gem.email = "pjotr.public01@thebird.nl"
  gem.authors = ["Pjotr Prins"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new do |features|
end

task :test => [ :spec, :cucumber ] 
task :default => [ :test ]

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bio-alignment #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
