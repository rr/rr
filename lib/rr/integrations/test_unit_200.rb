module RR
  module Integrations
    class TestUnit200
      def initialize
        @mt4_adapter = MiniTest4.new
        @tu_adapter = TestUnit1.new
      end

      def name
        'Test::Unit 2.0.0'
      end

      def applies?
        @mt4_adapter.applies? &&
        defined?(::Test::Unit) &&
        !@tu_adapter.has_test_unit_version? &&
        @tu_adapter.test_unit_just_wraps_minitest?
      end

      def hook
        @mt4_adapter.hook
      end
    end
  end
end
