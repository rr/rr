require 'rubygems'
require 'bundler'
require 'rake'

require 'pp'

# build, install, release
require 'bundler/gem_tasks'

default_tasks = []

begin
  # appraisal
  require 'appraisal'
rescue LoadError
else
  # appraisals
  Appraisal::File.each do |appraisal|
    desc "Resolve and install dependencies for the #{appraisal.name} appraisal"
    task "appraisal:#{appraisal.name}:install" do
      appraisal.install
    end
  end
  default_tasks << 'appraisal:install'
end

begin
  # spec
  require 'rspec/core/rake_task'
rescue LoadError
else
  require File.expand_path('../spec/defines_spec_suite_tasks', __FILE__)
  DefinesSpecSuiteTasks.call
  default_tasks << :spec
end

desc "Run tests"
task :test do
  ruby("test/run-test.rb")
end
default_tasks << :test

task :default => default_tasks
