require File.expand_path('../base', __FILE__)
require File.expand_path('../../matchers/be_a_subset_of_matcher', __FILE__)

module AdapterTests
  module RSpec
    include Base

    def self.included(base)
      base.class_eval do
        specify 'stubs work' do
          assert_stubs_work
        end

        specify 'mocks work' do
          assert_mocks_work
        end

        specify 'stub proxies work' do
          assert_stub_proxies_work
        end

        specify 'mock proxies work' do
          assert_mock_proxies_work
        end

        specify 'times-called verifications work' do
          assert_times_called_verifications_work
        end

        # RSpec-1 and RSpec-2's built-in adapter for RR
        # doesn't include have_received
        if method_defined?(:have_received)
          specify 'have_received works' do
            subject = Object.new
            stub(subject).foobar(1, 2)
            subject.foobar(1, 2)
            subject.should have_received.foobar(1, 2)

            expect {
              subject.should have_received.foobar(1, 2, 3)
            }.to raise_error(
              ::RSpec::Expectations::ExpectationNotMetError,
              /Expected foobar\(1, 2, 3\).+to be called 1 time/m
            )
          end
        end
      end
    end

    def assert_equal(expected, actual)
      expected.should be == actual
    end

    def assert_subset(subset, set)
      subset.should be_a_subset_of(set)
    end

    def assert_raises(error, &block)
      expect(&block).to raise_error(error)
    end

    def be_a_subset_of(set)
      BeASubsetOfMatcher.new(set)
    end
  end
end
