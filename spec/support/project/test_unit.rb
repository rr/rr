require File.expand_path('../test_unit_like', __FILE__)
require File.expand_path('../../test_file/test_unit', __FILE__)
require File.expand_path('../../test_helper/test_unit', __FILE__)

module Project
  module TestUnit
    include TestUnitLike

    attr_accessor :test_unit_gem_version

    def configure
      super
      if test_unit_gem_version
        gem_dependencies << gem_dependency(
          :name => 'test-unit',
          :version => test_unit_gem_version
        )
      end

      add_to_test_requires 'test/unit'#, :using_gem_original_require => test_unit_gem_version.nil?
    end

    def setup
      super
      test_file_generator.mixin TestFile::TestUnit
      test_helper_generator.mixin TestHelper::TestUnit
    end
  end
end
