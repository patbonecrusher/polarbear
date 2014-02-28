require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :spec 

RSpec::Core::RakeTask.new(:coverage) do |spec|
  # add simplecov
  ENV["COVERAGE"] = 'yes'

  # run the specs
  Rake::Task['spec'].execute
end


require 'rake/version_task'
Rake::VersionTask.new

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r polarbear.rb"
end
