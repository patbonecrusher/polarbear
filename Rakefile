require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :spec 

RSpec::Core::RakeTask.new(:coverage) do |spec|
  # add simplecov
  ENV["COVERAGE"] = 'yes'

  # run the specs
  Rake::Task['spec'].execute
end


