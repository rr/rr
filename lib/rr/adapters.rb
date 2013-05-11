module RR
  module Adapters
    class << self
      DEPRECATED_ADAPTERS = [
        :MiniTest,
        :TestUnit,
        :Rspec,
        :RSpec
      ]

      def const_missing(adapter_const_name)
        unless DEPRECATED_ADAPTERS.include?(adapter_const_name)
          super
          return
        end

        show_warning_for(adapter_const_name)

        adapter = shim_adapters[adapter_const_name] ||=
          case adapter_const_name
            when :TestUnit
              find_applicable_adapter(:TestUnit1, :TestUnit2ActiveSupport, :TestUnit2)
            when :Rspec, :RSpec
              find_applicable_adapter(:RSpec1, :RSpec2)
            when :MiniTest
              find_applicable_adapter(:MiniTestActiveSupport, :MiniTest4)
          end

        adapter
      end

      def build(adapter_const_name)
        const_get(adapter_const_name).new
      end

      private

      def shim_adapters
        @shim_adapters ||= {}
      end

      def find_applicable_adapter(*adapter_const_names)
        adapter = adapter_const_names.
          map { |adapter_const_name| RR::Adapters.build(adapter_const_name) }.
          find { |adapter| adapter.applies? }
        if adapter
          mod = Module.new
          (class << mod; self; end).class_eval do
            define_method(:included) do |base|
              # Note: This assumes that the thing that is including this module
              # is the same that the adapter detected and will hook into. In
              # most cases this will be true; in cases such as
              # ActiveSupport::TestCase, well, either stop doing this, or
              # require 'rr/without_autohook'.
              adapter.hook
            end
          end
          mod
        end
      end

      def show_warning_for(adapter_const_name)
        warn <<EOT
--------------------------------------------------------------------------------
RR deprecation warning: RR now has an autohook system. You don't need to
`include RR::Adapters::*` in your test framework's base class anymore.
--------------------------------------------------------------------------------
EOT
      end
    end
  end
end
