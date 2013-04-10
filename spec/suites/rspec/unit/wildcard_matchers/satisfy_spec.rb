require File.expand_path('../../../spec_helper', __FILE__)

module RR
  module WildcardMatchers
    describe Satisfy do
      include WildcardMatcherMatchers

      describe '#wildcard_match?' do
        let(:expectation_proc) { lambda {|v| v == 'x' } }
        subject { described_class.new(expectation_proc) }

        it "returns true if given Satisfy is a copy of this Satisfy" do
          matcher2 = described_class.new(expectation_proc)
          should wildcard_match(matcher2)
        end

        it "returns true if the given object matches the block" do
          should wildcard_match('x')
        end

        it "returns false otherwise" do
          should_not wildcard_match('y')
        end
      end

      describe '#==' do
        let(:expectation_proc) { lambda {|v| v == 'x' } }
        subject { described_class.new(expectation_proc) }

        it "returns true if given Satisfy is a copy of this Satisfy" do
          matcher2 = described_class.new(expectation_proc)
          should equal_match(matcher2)
        end

        it "returns false if given Satisfy is not a copy of this Satisfy" do
          matcher2 = described_class.new(lambda {|v| })
          should_not equal_match(matcher2)
        end

        it "returns false even when given an object that wildcard matches this Satisfy" do
          should_not equal_match('x')
        end

        it "returns false when given object isn't even a Satisfy" do
          should_not equal_match(:something_else)
        end
      end

      describe '#inspect' do
        it "returns the correct string" do
          matcher = Satisfy.new(lambda {})
          expect(matcher.inspect).to eq "satisfy { ... }"
        end
      end
    end
  end
end
