class Hash
  def wildcard_match?(other)
    return false unless other.is_a?(Hash)

    other_keys = other.keys
    return false if keys.size != other_keys.size

    other_values = other.values
    each_with_index do |(key, value), i|
      if key.respond_to?(:wildcard_match?)
        return false unless key.wildcard_match?(other_keys[i])
      else
        return false unless key == other_keys[i]
      end
      if value.respond_to?(:wildcard_match?)
        return false unless value.wildcard_match?(other_values[i])
      else
        return false unless value == other_values[i]
      end
    end
  end
end
