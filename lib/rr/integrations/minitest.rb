module RR
  module Integrations
    class Minitest < MiniTest4
      module Mixin
        def assert_received(subject, &block)
          # Increment Minitest's assertion counter
          self.assertions += 1

          super(subject, &block)
        end
      end

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

      def hook
        super # Call MiniTest4#hook includes MiniTest4::Mixin

        # explicitly include our own Mixin to override
        test_case_class.send(:include, Minitest::Mixin)
      end
    end

    RR.register_adapter Minitest
  end
end
