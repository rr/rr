class TestMockBlock < Test::Unit::TestCase
  test "anything" do
    object = Object.new
    anything_ = anything
    mock(object) do
      hello(anything_).once
    end
    object.hello("world")
  end
end
