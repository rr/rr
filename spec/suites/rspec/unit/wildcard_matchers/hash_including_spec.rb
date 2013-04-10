require File.expand_path('../../../spec_helper', __FILE__)

module RR
  module WildcardMatchers
    describe HashIncluding do
      include WildcardMatcherMatchers

      describe '#wildcard_match?' do
        subject { described_class.new({:foo => 'x'}) }

        it "returns true when given object is a copy of this HashIncluding" do
          matcher2 = described_class.new({:foo => 'x'})
          should wildcard_match(matcher2)
        end

        it "returns true when given hash is contained within expected hash" do
          should wildcard_match({:foo => 'x', :bar => 'y'})
        end

        it "returns false when given object is not a Hash" do
          should_not wildcard_match('whatever')
          should_not wildcard_match(:whatever)
          should_not wildcard_match([1, 2, 3])
        end

        it "returns false when given object is a hash but is not contained within expected hash" do
          should_not wildcard_match({:fiz => 'buz'})
        end
      end

      describe '#==' do
        subject { described_class.new({:foo => 'x'}) }

        it "returns true when given object is a copy of this HashIncluding" do
          matcher2 = described_class.new({:foo => 'x'})
          should equal_match(matcher2)
        end

        it "returns false when it is a HashIncluding but not with the same hash" do
          matcher2 = described_class.new({:x => 'y'})
          should_not equal_match(matcher2)
        end

        it "returns false even when given a hash that wildcard matches this HashIncluding" do
          should_not equal_match({:foo => 'x'})
        end

        it "returns false when not given a HashIncluding whatsoever" do
          should_not equal_match(:something_else)
        end
      end

      describe "#inspect" do
        it "returns the correct string" do
          matcher = described_class.new({:foo => 'x', :bar => 'y'})
          str = matcher.inspect
          expect(str).to include("hash_including(")
          expect(str).to include(':foo=>"x"')
          expect(str).to include(':bar=>"y"')
        end
      end
    end
  end
end
