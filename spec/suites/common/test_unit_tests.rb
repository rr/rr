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

    error_class = RR::Errors.error_class(
      RR::Errors::SpyVerificationErrors::InvocationCountError
    )
    assert_raise(error_class) do
      assert_received(subject) {|s| s.foobar(1, 2, 3) }
    end
  end
end
