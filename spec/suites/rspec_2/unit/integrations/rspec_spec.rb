require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

module RR
  module Integrations
    describe RSpec2 do
      attr_reader :fixture, :method_name

      describe "#setup_mocks_for_rspec" do
        subject { Object.new }

        before do
          @fixture = Object.new
          fixture.extend RSpec2::Mixin
          @method_name = :foobar
        end

        it "resets the double_injections" do
          stub(subject).foobar
          ::RR::Injections::DoubleInjection.instances.should_not be_empty

          fixture.setup_mocks_for_rspec
          expect(::RR::Injections::DoubleInjection.instances).to be_empty
        end
      end

      describe "#verify_mocks_for_rspec" do
        subject { Object.new }

        before do
          @fixture = Object.new
          fixture.extend RSpec2::Mixin
          @method_name = :foobar
        end

        it "verifies the double_injections" do
          mock(subject).foobar

          expect {
            fixture.verify_mocks_for_rspec
          }.to raise_error(::RR::Errors::TimesCalledError)
          expect(::RR::Injections::DoubleInjection.instances).to be_empty
        end
      end

      describe "#teardown_mocks_for_rspec" do
        subject { Object.new }

        before do
          @fixture = Object.new
          fixture.extend RSpec2::Mixin
          @method_name = :foobar
        end

        it "resets the double_injections" do
          stub(subject).foobar
          ::RR::Injections::DoubleInjection.instances.should_not be_empty

          fixture.teardown_mocks_for_rspec
          expect(::RR::Injections::DoubleInjection.instances).to be_empty
        end
      end

      describe "#trim_backtrace" do
        it "does not set trim_backtrace" do
          expect(RR.trim_backtrace).to eq false
        end
      end
    end
  end
end
