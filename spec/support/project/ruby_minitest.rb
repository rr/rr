require File.expand_path('../ruby', __FILE__)
require File.expand_path('../minitest', __FILE__)
require File.expand_path('../ruby_test_unit_like', __FILE__)

module Project
  module RubyMinitest
    include Ruby
    include Minitest
    include RubyTestUnitLike
  end
end
