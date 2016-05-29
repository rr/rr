require "ostruct"

class TestMockOpenStruct < Test::Unit::TestCase
  test "read twice" do
    open_struct = OpenStruct.new(:key => :value)
    mock(open_struct).dummy_key {:dummy_value}
    open_struct.dummy_key

    assert_equal(:value, open_struct.key)
    assert_equal(:value, open_struct.key)
  end
end
