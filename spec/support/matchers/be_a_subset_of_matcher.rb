class BeASubsetOfMatcher
  attr_reader :subset, :set

  def initialize(set)
    @set = set
  end

  def matches?(subset)
    @subset = subset
    (subset - set).empty?
  end

  def description
    "be a subset"
  end

  def failure_message_for_should
    "Expected to be a subset.\nSubset: #{subset.inspect}\nSet: #{set.inspect}"
  end

  def failure_message_for_should_not
    "Expected not to be a subset.\nSubset: #{subset.inspect}\nSet: #{set.inspect}"
  end
end
