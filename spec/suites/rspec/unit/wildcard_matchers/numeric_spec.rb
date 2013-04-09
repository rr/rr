require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

module RR
  module WildcardMatchers
    describe Numeric do
      include WildcardMatcherMatchers

      describe '#wildcard_match?' do
        it "returns true when given Numeric is a copy of this Numeric" do
          matcher2 = described_class.new
          should wildcard_match(matcher2)
        end

        it "returns true when given a Numeric" do
          should wildcard_match(99)
        end

        it "returns false otherwise" do
          should_not wildcard_match(:not_a_numeric)
        end
      end

      describe '#==' do
        it "returns true when given Numeric is a copy of this Numeric" do
          matcher2 = described_class.new
          should equal_match(matcher2)
        end

        it "returns false even when given an object that wildcard matches this Numeric" do
          should_not equal_match(99)
        end

        it "returns false when not a Numeric whatsoever" do
          should_not equal_match(:something_else)
        end
      end

      describe "#inspect" do
        it "returns the correct string" do
          matcher = described_class.new
          expect(matcher.inspect).to eq "numeric"
        end
      end
    end
  end
end
