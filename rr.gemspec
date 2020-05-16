# encoding: utf-8

require 'rake'
require File.expand_path('../lib/rr/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = 'rr'
  gem.version = RR.version
  gem.authors = ['Kouhei Sutou', 'Brian Takita', 'Elliot Winkler']
  gem.email = ['kou@cozmixng.org']
  gem.description = 'RR is a test double framework that features a rich selection of double techniques and a terse syntax.'
  gem.summary = 'RR is a test double framework that features a rich selection of double techniques and a terse syntax.'
  gem.homepage = 'https://rr.github.io/rr'
  gem.license = 'MIT'

  gem.files = FileList[
    'Appraisals',
    'CHANGES.md',
    'CREDITS.md',
    'Gemfile',
    'LICENSE',
    'README.md',
    'Rakefile',
    'doc/*.md',
    'gemfiles/**/*',
    'lib/**/*.rb',
    'rr.gemspec',
    'spec/**/*'
  ].to_a

  gem.require_paths = ['lib']

  gem.add_development_dependency("bundler")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("test-unit")
  gem.add_development_dependency("test-unit-rr")
end
