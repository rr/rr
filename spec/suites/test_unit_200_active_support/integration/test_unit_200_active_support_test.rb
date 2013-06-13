require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../common/test_unit_tests', __FILE__)

class TestUnit200ActiveSupportIntegrationTest < ActiveSupport::TestCase
  def applicable_adapter_names
    [:TestUnit200, :TestUnit200ActiveSupport, :MiniTest4, :MiniTest4ActiveSupport]
  end

  include TestUnitTests
end
