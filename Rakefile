require 'rubygems'
require 'rake'

require File.expand_path('../spec/suite', __FILE__)

SpecSuite.new.define_tasks(self)

task :default => :spec

begin
  require 'bundler'
  require 'bundler/gem_tasks'
rescue LoadError
  puts "Bundler isn't installed. Run `gem install bundler` to get it."
end

begin
  require 'cane/rake_task'

  desc "Check quality metrics"
  Cane::RakeTask.new(:quality) do |cane|
    cane.abc_max = 10
    cane.add_threshold 'coverage/covered_percent', :>=, 99
    cane.no_style = true
    cane.abc_exclude = %w(Foo::Bar#some_method)
  end
end
