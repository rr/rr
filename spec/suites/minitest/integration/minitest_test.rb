require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../common/test_unit_tests', __FILE__)

class MiniTestIntegrationTest < Minitest::Test
  # Test::Unit compatibility
  alias_method :assert_raise, :assert_raises

  def applicable_adapter_names
    [:Minitest]
  end

  include TestUnitTests
end
