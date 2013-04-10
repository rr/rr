require File.expand_path('../../../spec_helper', __FILE__)
require 'ostruct'

module RR
  module WildcardMatchers
    describe DuckType do
      include WildcardMatcherMatchers

      describe '#wildcard_match?' do
        subject { described_class.new(:quack, :waddle) }

        it "returns true when given DuckType is a copy of this DuckType" do
          matcher2 = described_class.new(:quack, :waddle)
          should wildcard_match(matcher2)
        end

        it "returns true when given object responds to all methods" do
          object = OpenStruct.new(:quack => 'x', :waddle => 'x')
          should wildcard_match(object)
        end

        it "returns false when given object responds to only some methods" do
          object = OpenStruct.new(:quack => 'x')
          should_not wildcard_match(object)
        end

        it "returns false when given object responds to no methods" do
          object = Object.new
          should_not wildcard_match(object)
        end
      end

      describe '#==' do
        subject { described_class.new(:quack, :waddle) }

        it "returns true when given DuckType is a copy of this DuckType" do
          matcher2 = described_class.new(:quack, :waddle)
          should equal_match(matcher2)
        end

        it "returns false when given DuckType is not a copy of this DuckType" do
          matcher2 = described_class.new(:something_else)
          should_not equal_match(matcher2)
        end

        it "returns false even when given a DuckType that wildcard matches this DuckType" do
          object = OpenStruct.new(:quack => 'x', :waddle => 'x')
          should_not equal_match(object)
        end

        it "returns false when not given a DuckType object whatsoever" do
          should_not equal_match(:something_else)
        end
      end

      describe "#inspect" do
        it "returns the correct string" do
          matcher = described_class.new(:quack, :waddle)
          expect(matcher.inspect).to eq "duck_type(:quack, :waddle)"
        end
      end
    end
  end
end
