require File.expand_path('../../test_file/rspec', __FILE__)
require File.expand_path('../../test_helper/rspec', __FILE__)

module Project
  module RSpec
    attr_accessor :rspec_version

    def setup
      super
      test_file_generator.mixin TestFile::RSpec
      test_helper_generator.mixin TestHelper::RSpec
    end

    def configure
      super
      gem_dependencies << gem_dependency(
        :name => 'rspec',
        :version => rspec_gem_version
      )
      add_to_test_requires(rspec_autorun_path)
      add_file(rspec_options_filename, dot_rspec_content)
    end

    def test_runner_command
      ruby_command('rake spec')
    end

    private

    def rspec_gem_version
      case rspec_version
        when 2   then '~> 2.13'
        when 1   then '~> 1.3'
        when nil then raise ArgumentError, "rspec_version isn't set!"
        else          raise ArgumentError, "Invalid RSpec version '#{rspec_version}'"
      end
    end

    def rspec_autorun_path
      if rspec_version == 1
        'spec/autorun'
      else
        'rspec/autorun'
      end
    end

    def rspec_options_filename
      if rspec_version == 1
        'spec/spec.opts'
      else
        '.rspec'
      end
    end

    def dot_rspec_content
      lines = []
      lines << '--color'
      if rspec_version == 1
        lines << '--format nested'
      else
        lines << '--format documentation'
      end
      if RR.debug?
        lines << '--backtrace'
      end
      lines.join("\n")
    end
  end
end
