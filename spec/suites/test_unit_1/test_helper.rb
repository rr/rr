require File.expand_path('../../../global_helper', __FILE__)
RR::Test.setup_test_suite(:test_unit_1)

require 'test/unit'
begin; require 'test/unit/version'; rescue LoadError; end
if defined?(::Test::Unit::VERSION)
  raise "You seem to have Test::Unit 2.x loaded!"
end

require 'rr'
