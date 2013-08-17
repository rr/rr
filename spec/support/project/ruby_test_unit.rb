require File.expand_path('../ruby_test_unit_like', __FILE__)
require File.expand_path('../test_unit', __FILE__)
require File.expand_path('../ruby', __FILE__)

module Project
  module RubyTestUnit
    include RubyTestUnitLike
    include TestUnit
    include Ruby
  end
end
