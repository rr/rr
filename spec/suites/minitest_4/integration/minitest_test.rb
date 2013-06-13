require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../common/test_unit_tests', __FILE__)

class MiniTestIntegrationTest < MiniTest::Unit::TestCase
  # Test::Unit compatibility
  alias_method :assert_raise, :assert_raises

  def applicable_adapter_names
    [:MiniTest4]
  end

  include TestUnitTests
end
