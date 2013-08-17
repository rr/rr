require File.expand_path('../../test_helper/ruby', __FILE__)

module Project
  module Ruby
    def setup
      super
      test_helper_generator.mixin TestHelper::Ruby
    end

    private

    def generate_skeleton
      super

      FileUtils.mkdir_p(directory)

      within do
        create_gemfile
        declare_and_install_gems
        create_files
      end
    end

    def create_gemfile
      File.open('Gemfile', 'w') do |f|
        contents = <<-EOT
          source 'https://rubygems.org'
          gem 'rake'
        EOT
        f.write(contents)
      end
    end
  end
end
