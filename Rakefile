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
