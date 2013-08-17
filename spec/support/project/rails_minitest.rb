require File.expand_path('../minitest', __FILE__)
require File.expand_path('../rails', __FILE__)
require File.expand_path('../../test_file/rails_minitest', __FILE__)
require File.expand_path('../../test_helper/rails_minitest', __FILE__)

module Project
  module RailsMinitest
    include Minitest
    include Rails

    def setup
      super
      test_file_generator.mixin TestFile::RailsMinitest
      test_helper_generator.mixin TestHelper::RailsMinitest
    end
  end
end
