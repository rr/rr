module RR
  module Adapters
    class TestUnit2 < TestUnit1
      def name
        'Test::Unit 2'
      end

      def applies?
        defined?(::Test::Unit) && has_test_unit_version?
      end
    end
  end
end
