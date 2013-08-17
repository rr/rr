require File.expand_path('../test_unit', __FILE__)

module TestCase
  module Minitest
    include TestUnit

    def include_adapter_tests
      add_to_before_tests <<-EOT
        include AdapterTests::Minitest
      EOT
    end
  end
end
