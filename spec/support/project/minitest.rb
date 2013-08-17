require File.expand_path('../test_unit_like', __FILE__)
require File.expand_path('../../test_file/minitest', __FILE__)
require File.expand_path('../../test_helper/minitest', __FILE__)

module Project
  module Minitest
    include TestUnitLike

    attr_accessor :minitest_version

    def configure
      super
      if minitest_version
        gem_dependencies << gem_dependency(
          :name => 'minitest',
          :version => minitest_gem_version
        )
      end
      add_to_test_requires 'minitest/autorun'
    end

    def setup
      super
      test_file_generator.mixin TestFile::Minitest
      test_helper_generator.mixin TestHelper::Minitest
    end

    private

    def minitest_gem_version
      case minitest_version
        when 4   then '~> 4.0'
        when 5   then '~> 5.0'
        when nil then raise ArgumentError, "minitest_version isn't set!"
        else          raise ArgumentError, "Invalid Minitest version '#{minitest_version}'"
      end
    end
  end
end
