module RR
  module Integrations
    class Minitest < MiniTest4
      def name
        'Minitest'
      end

      def applies?
        mt_version >= 5
      rescue NameError
        false
      end

      def test_case_class
        ::Minitest::Test
      end

      def assertion_error_class
        ::Minitest::Assertion
      end

      def version_constant
        ::Minitest::VERSION
      end
    end

    RR.register_adapter Minitest
  end
end
