require File.expand_path('../../test_helper', __FILE__)
require File.expand_path('../../../common/test_unit_tests', __FILE__)

class TestUnit2ActiveSupportIntegrationTest < ActiveSupport::TestCase
  def applicable_adapter_names
    [:TestUnit2, :TestUnit2ActiveSupport]
  end

  include TestUnitTests
end
