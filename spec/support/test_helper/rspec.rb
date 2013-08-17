module TestHelper
  module RSpec
    def path
      File.join(project.directory, 'spec/spec_helper.rb')
    end
  end
end
