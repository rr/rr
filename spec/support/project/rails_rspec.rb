require File.expand_path('../rspec', __FILE__)
require File.expand_path('../rails', __FILE__)
require File.expand_path('../../test_file/rails_rspec', __FILE__)
require File.expand_path('../../test_helper/rails_rspec', __FILE__)

module Project
  module RailsRSpec
    include RSpec
    include Rails

    def setup
      super
      test_file_generator.mixin TestFile::RailsRSpec
      test_helper_generator.mixin TestHelper::RailsRSpec
    end

    def configure
      super
      gem_dependencies << gem_dependency(
        :name => 'rspec-rails',
        :version => rspec_gem_version,
        :group => [:development, :test]
      )
      add_to_test_requires(rspec_rails_path)
    end

    def generate_skeleton
      super
      run_command_within!(generate_rspec_command)
    end

    private

    def rspec_rails_path
      if rails_version == 2
        'spec/rails'
      else
        'rspec/rails'
      end
    end

    def generate_rspec_command
      if rails_version == 2
        ruby_command('script/generate rspec --skip')
      else
        ruby_command('rails generate rspec:install --skip')
      end
    end
  end
  end
