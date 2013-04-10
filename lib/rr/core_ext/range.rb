class Range
  def wildcard_match?(other)
    self == other ||
    (other.is_a?(Numeric) && include?(other))
  end

  alias_method :eql, :==
end
