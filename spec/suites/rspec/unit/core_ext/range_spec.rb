require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

describe Range do
  include WildcardMatcherMatchers

  describe '#wildcard_match?' do
    subject { 1..5 }

    it "returns true when given Range is exactly equal to this Range" do
      should wildcard_match(1..5)
    end

    it "returns true when given number falls within the range" do
      should wildcard_match(3)
    end

    it "returns false when given number falls outside the range" do
      should_not wildcard_match(8)
    end
  end

  describe '#==' do
    subject { 1..5 }

    it "returns true when given Range is exactly equal to this Range" do
      should equal_match(1..5)
    end

    it "returns false when given Range is not exactly equal to this Range" do
      should_not equal_match(3..5)
    end

    it "returns false even when given an object that wildcard matches this Range" do
      should_not equal_match(3)
    end

    it "returns false when given object isn't even a Range" do
      should_not equal_match(:something_else)
    end
  end
end
