require 'forwardable'

require 'rr/core_ext/enumerable'
require 'rr/core_ext/hash'
require 'rr/core_ext/array'
require 'rr/core_ext/range'
require 'rr/core_ext/regexp'

require 'rr/keyword_arguments'

require 'rr/class_instance_method_defined'
require 'rr/blank_slate'

require 'rr/errors'
require 'rr/errors/rr_error'
require 'rr/errors/subject_does_not_implement_method_error'
require 'rr/errors/subject_has_different_arity_error'
require 'rr/errors/double_definition_error'
require 'rr/errors/double_not_found_error'
require 'rr/errors/double_order_error'
require 'rr/errors/times_called_error'
require 'rr/errors/spy_verification_errors/spy_verification_error'
require 'rr/errors/spy_verification_errors/double_injection_not_found_error'
require 'rr/errors/spy_verification_errors/invocation_count_error'

require 'rr/space'

require 'rr/double_definitions/strategies/strategy'
require 'rr/double_definitions/strategies/strategy_methods'
require 'rr/double_definitions/strategies/verification/verification_strategy'
require 'rr/double_definitions/strategies/verification/mock'
require 'rr/double_definitions/strategies/verification/stub'
require 'rr/double_definitions/strategies/verification/dont_allow'
require 'rr/double_definitions/strategies/implementation/implementation_strategy'
require 'rr/double_definitions/strategies/implementation/reimplementation'
require 'rr/double_definitions/strategies/implementation/strongly_typed_reimplementation'
require 'rr/double_definitions/strategies/implementation/proxy'
require 'rr/double_definitions/strategies/double_injection/double_injection_strategy'
require 'rr/double_definitions/strategies/double_injection/instance'
require 'rr/double_definitions/strategies/double_injection/any_instance_of'
require 'rr/dsl'
require 'rr/double_definitions/double_injections/instance'
require 'rr/double_definitions/double_injections/any_instance_of'
require 'rr/double_definitions/double_definition'

require 'rr/injections/injection'
require 'rr/injections/double_injection'
require 'rr/injections/method_missing_injection'
require 'rr/injections/singleton_method_added_injection'
require 'rr/method_dispatches/base_method_dispatch'
require 'rr/method_dispatches/method_dispatch'
require 'rr/method_dispatches/method_missing_dispatch'
require 'rr/hash_with_object_id_key'
require 'rr/recorded_call'
require 'rr/recorded_calls'

require 'rr/double_definitions/double_definition_create_blank_slate'
require 'rr/double_definitions/double_definition_create'
require 'rr/double_definitions/child_double_definition_create'

require 'rr/double'
require 'rr/double_matches'

require 'rr/expectations/argument_equality_expectation'
require 'rr/expectations/any_argument_expectation'
require 'rr/expectations/times_called_expectation'

require 'rr/wildcard_matchers/anything'
require 'rr/wildcard_matchers/is_a'
require 'rr/wildcard_matchers/numeric'
require 'rr/wildcard_matchers/boolean'
require 'rr/wildcard_matchers/duck_type'
require 'rr/wildcard_matchers/satisfy'
require 'rr/wildcard_matchers/hash_including'

require 'rr/times_called_matchers/terminal'
require 'rr/times_called_matchers/non_terminal'
require 'rr/times_called_matchers/times_called_matcher'
require 'rr/times_called_matchers/never_matcher'
require 'rr/times_called_matchers/any_times_matcher'
require 'rr/times_called_matchers/integer_matcher'
require 'rr/times_called_matchers/range_matcher'
require 'rr/times_called_matchers/proc_matcher'
require 'rr/times_called_matchers/at_least_matcher'
require 'rr/times_called_matchers/at_most_matcher'

require 'rr/spy_verification_proxy'
require 'rr/spy_verification'

require 'rr/integrations'
require 'rr/integrations/decorator'
require 'rr/integrations/rspec/invocation_matcher'
require 'rr/integrations/rspec_2'
require 'rr/integrations/minitest_4'
require 'rr/integrations/minitest_4_active_support'
require 'rr/integrations/minitest'
require 'rr/integrations/minitest_active_support'

require 'rr/deprecations'

require 'rr/version'

module RR
  class << self
    include DSL

    (RR::Space.instance_methods - Object.instance_methods).each do |method_name|
      class_eval((<<-METHOD), __FILE__, __LINE__ + 1)
        def #{method_name}(*args, &block)
          RR::Space.instance.__send__(:#{method_name}, *args, &block)
        end
      METHOD
    end

    attr_accessor :debug
    alias_method :debug?, :debug
  end
end

RR.debug = (ENV['RR_DEBUG'] == '1')
