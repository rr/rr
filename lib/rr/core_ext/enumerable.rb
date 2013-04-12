module Enumerable
  def wildcard_match?(other)
    if is_a?(String)
      return RR::Expectations::ArgumentEqualityExpectation.recursive_safe_eq(self, other)
    end
    return false unless other.is_a?(Enumerable)
    other_entries = other.entries
    each_with_index do |value, i|
      if value.respond_to?(:wildcard_match?)
        return false unless value.wildcard_match?(other_entries[i])
      else
        return false unless value == other_entries[i]
      end
    end
  end
end
