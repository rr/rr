require File.expand_path('../adapter_tests', __FILE__)

module TestUnitTests
  def self.included(base)
    base.class_eval { include AdapterTests }
  end

  def test_using_assert_received
    subject = Object.new
    stub(subject).foobar(1, 2)
    subject.foobar(1, 2)
    assert_received(subject) {|s| s.foobar(1, 2) }

    assert_raise(RR::Errors::SpyVerificationErrors::InvocationCountError) do
      assert_received(subject) {|s| s.foobar(1, 2, 3) }
    end
  end

  def test_trim_backtrace_is_set
    assert RR.trim_backtrace
  end
end
