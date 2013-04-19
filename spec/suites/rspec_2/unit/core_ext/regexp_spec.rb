require File.expand_path('../../../spec_helper', __FILE__)

describe Regexp do
  include WildcardMatcherMatchers

  describe '#wildcard_match?' do
    subject { /foo/ }

    it "returns true when given Regexp is exactly equal to this Regexp" do
      should wildcard_match(/foo/)
    end

    it "returns true if given string matches the regexp" do
      should wildcard_match('foobarbaz')
    end

    it "returns false if given string does not match the regexp" do
      should_not wildcard_match('aslkj')
    end
  end

  describe '#==' do
    subject { /foo/ }

    it "returns true when given Regexp is exactly equal to this Regexp" do
      should equal_match(/foo/)
    end

    it "returns false when given Regexp is not exactly equal to this Regexp" do
      should_not equal_match(/alkj/)
    end

    it "returns false even when given an object that wildcard matches this Regexp" do
      should_not equal_match('foobarbaz')
    end

    it "returns false when not even given a Regexp" do
      should_not equal_match(:something_else)
    end
  end
end
