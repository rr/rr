class Hash
  def wildcard_match?(other)
    return false unless other.is_a?(Hash)

    return false if size != other.size

    wildcards, exacts = partition {|key, _| key.respond_to?(:wildcard_match?)}
    other = other.dup
    exacts.each do |key, value|
      return false unless other.key?(key)
      other_value = other.delete(key)
      if value.respond_to?(:wildcard_match?)
        return false unless value.wildcard_match?(other_value)
      else
        return false unless value == other_value
      end
    end
    # TODO: Add support for the following case:
    #   {
    #      is_a(Symbol) => anything,
    #      is_a(Symbol) => 1,
    #   }.wildcard_match?(d: 1, c: 3)
    wildcards.each do |key, value|
      found = false
      other.each do |other_key, other_value|
        next unless key.wildcard_match?(other_key)
        if value.respond_to?(:wildcard_match?)
          next unless value.wildcard_match?(other_value)
        else
          next unless value == other_value
        end
        other.delete(other_key)
        found = true
        break
      end
      return false unless found
    end

    true
  end
end
