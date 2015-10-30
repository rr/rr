module RR
  module Adapters
    # People who manually include RR into their test framework will use
    # these constants

    module MiniTest
      def self.included(base)
        RR::Deprecations.show_warning_for_deprecated_adapter
        RR.autohook
      end
    end

    module TestUnit
      def self.included(base)
        RR::Deprecations.show_warning_for_deprecated_adapter
        RR.autohook
      end
    end

    module RSpec2
      def self.included(base)
        RR::Deprecations.show_warning_for_deprecated_adapter
        RR.autohook
      end
    end

    module Rspec
      def self.const_missing(name)
        if name == :InvocationMatcher
          # Old versions of the RSpec-2 adapter for RR floating out in the wild
          # still refer to this constant
          RR::Deprecations.constant_deprecated_in_favor_of(
            'RR::Adapters::Rspec::InvocationMatcher',
            'RR::Integrations::RSpec::InvocationMatcher'
          )
          RR::Integrations::RSpec::InvocationMatcher
        else
          super
        end
      end
    end

    module RRMethods
      include RR::DSL

      def self.included(base)
        # This was once here but is now deprecated
        RR::Deprecations.constant_deprecated_in_favor_of(
          'RR::Adapters::RRMethods',
          'RR::DSL'
        )
      end
    end
  end

  # This is here because RSpec-2's RR adapters uses it
  module Extensions
    def self.const_missing(name)
      if name == :InstanceMethods
        RR.autohook
        RR::Integrations::RSpec2::Mixin
      else
        super
      end
    end
  end

  module Deprecations
    def self.show_warning(msg, options = {})
      start_backtrace_at_frame = options.fetch(:start_backtrace_at_frame, 2)
      backtrace = caller(start_backtrace_at_frame)

      lines = []
      lines << ('-' * 80)
      lines << 'Warning from RR:'
      lines.concat msg.split(/\n/).map {|l| "  #{l}" }
      lines << ""
      lines << "Called from:"
      lines.concat backtrace[0..2].map {|l| " - #{l}" }
      lines << ('-' * 80)

      Kernel.warn lines.join("\n")
    end

    def self.constant_deprecated_in_favor_of(old_name, new_name)
      show_warning "#{old_name} is deprecated;\nplease use #{new_name} instead.",
        :start_backtrace_at_frame => 3
    end

    def self.show_warning_for_deprecated_adapter
      RR::Deprecations.show_warning(<<EOT.strip)
RR now has an autohook system. You don't need to `include RR::Adapters::*` in
your test framework's base class anymore.
EOT
    end
  end
end
