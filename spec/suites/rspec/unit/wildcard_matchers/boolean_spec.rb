require File.expand_path('../../../spec_helper', __FILE__)

module RR
  module WildcardMatchers
    describe Boolean do
      include WildcardMatcherMatchers

      describe '#wildcard_match?' do
        it "returns true when given a Boolean" do
          should wildcard_match(described_class.new)
        end

        it "returns true when given a boolean" do
          should wildcard_match(true)
          should wildcard_match(false)
        end

        it "returns false when not given a boolean" do
          should_not wildcard_match(:something_else)
        end
      end

      describe "#==" do
        it "returns true when given a Boolean" do
          should equal_match(described_class.new)
        end

        it "returns false even when given a boolean that wildcard matches this Boolean" do
          should_not equal_match(true)
          should_not equal_match(false)
        end

        it "returns false when not given a Boolean whatsoever" do
          should_not equal_match(:something_else)
        end
      end

      describe "#inspect" do
        it "returns the correct string" do
          expect(subject.inspect).to eq "boolean"
        end
      end
    end
  end
end
