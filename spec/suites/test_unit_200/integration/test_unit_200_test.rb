require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../common/test_unit_tests', __FILE__)

class TestUnitIntegrationTest < Test::Unit::TestCase
  def applicable_adapter_names
    [:TestUnit200, :MiniTest4]
  end

  include TestUnitTests
end
