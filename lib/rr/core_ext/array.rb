class Array
  def wildcard_match?(other)
    return false unless other.is_a?(Array)
    return false unless size == other.size

    each_with_index do |value, i|
      if value.respond_to?(:wildcard_match?)
        return false unless value.wildcard_match?(other[i])
      else
        return false unless value == other[i]
      end
    end
  end
end
