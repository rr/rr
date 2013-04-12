module WildcardMatcherMatchers
  extend RSpec::Matchers::DSL

  matcher :equal_match do |value|
    match { |matcher|
      matcher == value &&
      matcher.eql?(value)
    }

    failure_message_for_should {
      "Expected matcher to equal match #{value.inspect}, but it didn't"
    }

    failure_message_for_should_not {
      "Expected matcher to not equal match #{value.inspect}, but it did"
    }
  end

  matcher :wildcard_match do |value|
    match { |matcher|
      matcher.wildcard_match?(value)
    }

    failure_message_for_should {
      "Expected matcher to wildcard equal match #{value.inspect}, but it didn't"
    }

    failure_message_for_should_not {
      "Expected matcher to not wildcard equal match #{value.inspect}, but it did"
    }
  end
end
