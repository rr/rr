require File.expand_path('../spec_suite_runner', __FILE__)

require 'yaml'
require 'erb'
require 'forwardable'
require 'ostruct'

class SpecSuiteConfiguration
  SUITES_CONFIG_FILE = File.expand_path('../suites.yml', __FILE__)
  TRAVIS_CONFIG_FILE = File.expand_path('../../.travis.yml', __FILE__)

  class Suite < Struct.new(:name, :desc, :rvm_version, :ruby_id, :env, :travis)
    attr_reader :runner

    def initialize(name, desc, rvm_version, ruby_id, env, travis)
      super
      @runner = SpecSuiteRunner.new(self)
    end

    def appraisal_name
      "ruby_#{ruby_id}_#{name}"
    end

    def run
      runner.call
    end

    def current_ruby_id
      '19'
    end

    def matching_current_ruby_version?
      ruby_id == current_ruby_id
    end
  end

  attr_reader :ruby_groups, :runners

  def self.build
    new(parse)
  end

  def self.parse
    suites = []
    yaml = ERB.new(File.read(SUITES_CONFIG_FILE)).result(binding)
    ruby_groups = YAML.load(yaml)
    ruby_groups.each do |ruby_id, ruby_group|
      base_env = ruby_group.fetch('env', {})
      ruby_group['suites'].each do |suite|
        ruby_group['rvm_versions'].each do |rvm_version|
          suite = suite.dup
          suite['ruby_id'] = ruby_id.to_s
          suite['rvm_version'] = rvm_version['name']
          suite['env'] = base_env.merge(rvm_version.fetch('env', {}))
          suite['travis'] = ruby_group.fetch('travis', {})
          suite['travis']['env'] = base_env.merge(suite['travis'].fetch('env', {}))
          suites << suite
        end
      end
    end
    suites
  end

  def self.root_dir
    File.expand_path('../..', __FILE__)
  end

  attr_reader :suites

  def initialize(suites)
    @suites = suites.map do |suite|
      Suite.new(
        suite['name'],
        suite['desc'],
        suite['rvm_version'],
        suite['ruby_id'],
        suite['env'],
        suite['travis']
      )
    end
  end

  def each_matching_suite(&block)
    suites.
      select { |suite| suite.matching_current_ruby_version? }.
      each(&block)
  end

  def to_travis_config
    inclusions = []
    allowed_failures = []

    sorted_suites = suites.sort_by { |suite| [suite.rvm_version, suite.name] }

    sorted_suites.each do |suite|
      env = suite.travis['env'].merge('SUITE' => suite.name)
      row = {
        'rvm' => suite.rvm_version,
        'env' => env.map { |key, val| "#{key}=#{val.inspect}" }
      }
      inclusions << row
      if suite.rvm_version == 'jruby-19mode'
        allowed_failures << row
      end
    end
    {
      'language' => 'ruby',
      'script' => 'rake spec:${SUITE}',
      'rvm' => '1.9.3',
      'matrix' => {
        # exclude default row
        'exclude' => [
          {'rvm' => '1.9.3'},
        ],
        'include' => inclusions,
        'allow_failures' => allowed_failures
      }
    }
  end

  def generate_travis_config
    config = to_travis_config
    File.open(TRAVIS_CONFIG_FILE, 'w') {|f| YAML.dump(config, f) }
    puts "Updated .travis.yml."
  end
end
