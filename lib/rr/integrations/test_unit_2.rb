module RR
  module Integrations
    class TestUnit2 < TestUnit1
      def name
        RR.ruby_18? ? 'Test::Unit 2.4.x' : 'Test::Unit >= 2.5'
      end

      def applies?
        defined?(::Test::Unit) &&
        defined?(::Test::Unit::TestCase) &&
        has_test_unit_version?
      end
    end

    RR.register_adapter TestUnit2
  end
end
