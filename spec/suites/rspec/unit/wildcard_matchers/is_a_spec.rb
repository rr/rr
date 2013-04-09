require File.expand_path('../../../spec_helper', __FILE__)

module RR
  module WildcardMatchers
    describe IsA do
      include WildcardMatcherMatchers

      describe '#wildcard_match?' do
        subject { described_class.new(Symbol) }

        it "returns true when given IsA is a copy of this IsA" do
          matcher2 = described_class.new(Symbol)
          should wildcard_match(matcher2)
        end

        it "returns true when given an object that is is_a?(klass)" do
          should wildcard_match(:a_symbol)
        end

        it "returns false if not given an object that is is_a?(klass)" do
          should_not wildcard_match('a string')
        end
      end

      describe '#==' do
        subject { described_class.new(Symbol) }

        it "returns true when given IsA is a copy of this IsA" do
          matcher2 = described_class.new(Symbol)
          should equal_match(matcher2)
        end

        it "returns false when given IsA is not a copy of this IsA" do
          matcher2 = described_class.new(String)
          should_not equal_match(matcher2)
        end

        it "returns false even when given an object that wildcard matches this IsA" do
          should_not equal_match(:something_else)
        end

        it "returns false when not given an IsA whatsoever" do
          should_not equal_match([1, 2, 3])
        end
      end

      describe "#inspect" do
        it "returns the correct string" do
          matcher = described_class.new(Symbol)
          expect(matcher.inspect).to eq "is_a(Symbol)"
        end
      end
    end
  end
end
