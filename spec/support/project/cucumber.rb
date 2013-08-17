module Project
  module Cucumber
    def configure
      super
      gem_dependencies << gem_dependency(
        :name => 'cucumber-rails',
        :version => cucumber_gem_version,
        :require => false
      )
      if rails_version == 2
        gem_dependencies << gem_dependency(
          :name => 'capybara',
          :version => '~> 0.4.0'
        )
        # 1.5.0 is only compatible with >= 1.9.2
        gem_dependencies << gem_dependency(
          :name => 'nokogiri',
          :version => '~> 1.4.0'
        )
      end
      gem_dependencies << gem_dependency(
        :name => 'database_cleaner'
      )
    end

    def generate_skeleton
      super

      if rails_version == 2
        run_command_within! ruby_command('script/generate cucumber --capybara --backtrace')
      else
        run_command_within! ruby_command('rails generate cucumber:install')
      end
    end

    def test_runner_command
      'cucumber'
    end

    private

    def cucumber_gem_version
      if rails_version == 2
        '~> 0.3.2'
      else
        '~> 1.3.1'
      end
    end
  end
end
