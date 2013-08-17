require File.expand_path('../test_unit', __FILE__)
require File.expand_path('../rails', __FILE__)
require File.expand_path('../../test_file/rails_test_unit', __FILE__)
require File.expand_path('../../test_helper/rails_test_unit', __FILE__)

module Project
  module RailsTestUnit
    include TestUnit
    include Rails

    def setup
      super
      test_file_generator.mixin TestFile::RailsTestUnit
      test_helper_generator.mixin TestHelper::RailsTestUnit
    end
  end
end
