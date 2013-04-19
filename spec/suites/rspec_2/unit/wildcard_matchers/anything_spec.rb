require File.expand_path('../../../spec_helper', __FILE__)

module RR
  module WildcardMatchers
    describe Anything do
      include WildcardMatcherMatchers

      describe '#wildcard_match?' do
        it "always returns true when given any object" do
          should wildcard_match(Object.new)
          should wildcard_match(:symbol)
          should wildcard_match([1, 2, 3])
        end
      end

      describe '#==' do
        it "returns true when given an Anything object" do
          should equal_match(described_class.new)
        end

        it "returns false when not given an Anything object whatsoever" do
          should_not equal_match(:whatever)
        end
      end

      describe "#inspect" do
        it "returns the correct string" do
          expect(subject.inspect).to eq "anything"
        end
      end
    end
  end
end
