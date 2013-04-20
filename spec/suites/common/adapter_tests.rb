module AdapterTests
  def test_using_a_mock
    subject = Object.new
    mock(subject).foobar(1, 2) { :baz }
    assert_equal :baz, subject.foobar(1, 2)
  end

  def test_using_a_stub
    subject = Object.new
    stub(subject).foobar { :baz }
    assert_equal :baz, subject.foobar("any", "thing")
  end

  def test_using_a_mock_proxy
    subject = Object.new
    def subject.foobar; :baz; end

    mock.proxy(subject).foobar
    assert_equal :baz, subject.foobar
  end

  def test_using_a_stub_proxy
    subject = Object.new
    def subject.foobar; :baz; end

    stub.proxy(subject).foobar
    assert_equal :baz, subject.foobar
  end

  def test_times_called_verification
    subject = Object.new
    mock(subject).foobar(1, 2) { :baz }
    assert_raise RR::Errors::TimesCalledError do
      RR.verify
    end
  end
end
