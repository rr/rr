require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../common/test_unit_tests', __FILE__)

test_case_superclass = (defined?(Minitest) && defined?(Minitest::VERSION)) ? \
  Minitest::Test : \
  MiniTest::Unit::TestCase

class MiniTestIntegrationTest < test_case_superclass
  # Test::Unit compatibility
  alias_method :assert_raise, :assert_raises

  include TestUnitTests
end
