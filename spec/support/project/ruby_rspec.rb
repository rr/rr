require File.expand_path('../ruby', __FILE__)
require File.expand_path('../rspec', __FILE__)

module Project
  module RubyRSpec
    include Ruby
    include RSpec

    def configure
      super
      if rspec_version == 1
        add_file 'Rakefile', <<-EOT
          require 'spec/rake/spectask'
          Spec::Rake::SpecTask.new(:spec)
        EOT
      else
        add_file 'Rakefile', <<-EOT
          require 'rspec/core/rake_task'
          RSpec::Core::RakeTask.new(:spec)
        EOT
      end
    end

    def generate_skeleton
      super
      FileUtils.mkdir_p File.join(directory, 'spec')
    end
  end
end
