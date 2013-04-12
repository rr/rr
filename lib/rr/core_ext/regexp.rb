class Regexp
  def wildcard_match?(other)
    self == other ||
    !!(other.is_a?(String) && other =~ self)
  end

  alias_method :eql?, :==
end
