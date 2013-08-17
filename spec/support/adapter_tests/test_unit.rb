require File.expand_path('../base', __FILE__)

module AdapterTests
  module TestUnit
    include Base

    def test_that_stubs_work
      assert_stubs_work
    end

    def test_that_mocks_work
      assert_mocks_work
    end

    def test_that_stub_proxies_work
      assert_stub_proxies_work
    end

    def test_that_mock_proxies_work
      assert_mock_proxies_work
    end

    def test_that_times_called_verifications_work
      assert_times_called_verifications_work
    end

    def test_using_assert_received
      subject = Object.new
      stub(subject).foobar(1, 2)
      subject.foobar(1, 2)
      assert_received(subject) {|s| s.foobar(1, 2) }

      error_class = RR::Errors.error_class(
        RR::Errors::SpyVerificationErrors::InvocationCountError
      )
      assert_raises(error_class) do
        assert_received(subject) {|s| s.foobar(1, 2, 3) }
      end
    end

    def assert_subset(subset, set)
      value = (subset - set).empty?
      message = "Set 1 was not a subset of set 2.\nSet 1: #{subset.inspect}\nSet 2: #{set.inspect}"
      assert value, message
    end
  end
end
