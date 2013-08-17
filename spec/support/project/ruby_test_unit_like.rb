module Project
  module RubyTestUnitLike
    def setup
      super

      add_file 'Rakefile', <<-EOT
        require 'rake/testtask'

        Rake::TestTask.new do |t|
          t.libs << 'test'
          t.test_files = FileList['test/*_test.rb']
        end
      EOT
    end

    def generate_skeleton
      super
      FileUtils.mkdir_p File.join(directory, 'test')
    end
  end
end
