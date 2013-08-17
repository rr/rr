require File.expand_path('../spec_suite_configuration', __FILE__)

require 'ostruct'

class DefinesSpecSuiteTasks
  extend Rake::DSL

  def self.configuration
    @configuration ||= SpecSuiteConfiguration.build
  end

  def self.call
    desc 'Run all tests'
    task :spec do
      results = []
      DefinesSpecSuiteTasks.configuration.each_matching_suite.each do |suite|
        puts "=== Running #{suite.desc} tests ================================================"
        results << suite.run
        puts
      end
      if results.any? { |result| not result.success? }
        raise 'Spec suite failed!'
      end
    end

    namespace :spec do
      DefinesSpecSuiteTasks.configuration.each_matching_suite do |suite|
        desc "Run #{suite.desc} tests"
        task suite.name => "appraisal:#{suite.appraisal_name}:install" do
          result = suite.run
          if not result.success?
            raise "#{suite.desc} suite failed!"
          end
        end
      end
    end

    namespace :travis do
      desc 'Regenerate .travis.yml'
      task :regenerate_config do
        DefinesSpecSuiteTasks.configuration.generate_travis_config
      end
    end
  end
end
