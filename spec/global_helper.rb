require 'pp'
require 'rubygems'
require 'bundler'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

module RR
  module Test
    def self.setup_test_suite(adapter_name)
      puts "Setting up test suite for #{adapter_name}" if ENV['RR_DEBUG']
      unset_bundler_vars
      adapter = Adapter.new(adapter_name)
      ENV['ADAPTER'] = adapter.name.to_s
      puts "Using appraisal: #{adapter.appraisal.name}" if ENV['RR_DEBUG']
      ENV['BUNDLE_GEMFILE'] = adapter.appraisal.gemfile_path
      puts "Using gemfile: #{adapter.appraisal.gemfile_path}" if ENV['RR_DEBUG']
      Bundler.setup(:default)
      $:.unshift File.expand_path('../../lib', __FILE__)
    end

    def self.unset_bundler_vars
      # Copied from appraisal
      %w(RUBYOPT BUNDLE_PATH BUNDLE_BIN_PATH BUNDLE_GEMFILE).each do |name|
        ENV[name] = nil
      end
    end
  end
end

lib_path = File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

Dir[ File.expand_path('../support/**/*.rb', __FILE__) ].each { |fn| require fn }

$stdout.sync = true
