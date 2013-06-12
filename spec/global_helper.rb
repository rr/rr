require 'pp'
require 'rubygems'
require 'appraisal/file'
require 'bundler'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

module RR
  module Test
    class Adapter
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def appraisal_name
        parts = []
        parts << (RUBY_VERSION =~ /^1\.8/ ? 'ruby_18' : 'ruby_19')
        parts << name
        parts.join('_')
      end

      def appraisal
        @appraisal ||= Appraisal::File.new.appraisals.find do |appraisal|
          appraisal.name == appraisal_name
        end
      end
    end

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
