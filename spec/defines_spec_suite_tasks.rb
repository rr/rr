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

      require 'rspec/core/rake_task'

      desc "Run the unit tests"
      RSpec::Core::RakeTask.new(:unit) do |t|
        t.pattern = 'spec/suites/rspec_2/unit/**/*_spec.rb'
      end

      desc "Run the functional (API) tests"
      RSpec::Core::RakeTask.new(:functional) do |t|
        t.pattern = 'spec/suites/rspec_2/functional/**/*_spec.rb'
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
