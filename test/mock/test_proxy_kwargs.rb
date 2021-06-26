class TestMockProxyKwargs < Test::Unit::TestCase
  def call_method(object, style)
    case style
    when :kwargs
      object.call(1, a: 2)
    when :hash
      object.call(1, {a: 2})
    when :kwrest
      object.call(1, **{a: 2})
    end
  end

  data(:style, [:kwargs, :hash, :kwrest], keep: true)
  test "a, b" do
    klass = Class.new do
      def call(a, b)
        [a, b]
      end
    end
    obj1 = klass.new
    obj2 = klass.new
    proxy.mock(obj2).call.with_any_args
    assert_equal(call_method(obj1, data[:style]),
                 call_method(obj2, data[:style]))
  end

  test "a, **b" do
    klass = Class.new do
      def call(a, **b)
        [a, b]
      end
    end
    obj1 = klass.new
    obj2 = klass.new
    proxy.mock(obj2).call.with_any_args
    if data[:style] == :hash && RR::KeywordArguments.fully_supported?
      assert_raise(ArgumentError) do
        obj1.call(1, {a: 2})
      end
      assert_raise(ArgumentError) do
        obj2.call(1, {a: 2})
      end
    else
      assert_equal(call_method(obj1, data[:style]),
                   call_method(obj2, data[:style]))
    end
  end

  test "*a" do
    klass = Class.new do
      def call(*a)
        [a]
      end
    end
    obj1 = klass.new
    obj2 = klass.new
    proxy.mock(obj2).call.with_any_args
    assert_equal(call_method(obj1, data[:style]),
                 call_method(obj2, data[:style]))
  end

  test "*a, **b" do
    klass = Class.new do
      def call(*a, **b)
        [a, b]
      end
    end
    obj1 = klass.new
    obj2 = klass.new
    proxy.mock(obj2).call.with_any_args
    assert_equal(call_method(obj1, data[:style]),
                 call_method(obj2, data[:style]))
  end

  test "a, *b" do
    klass = Class.new do
      def call(a, *b)
        [a, b]
      end
    end
    obj1 = klass.new
    obj2 = klass.new
    proxy.mock(obj2).call.with_any_args
    assert_equal(call_method(obj1, data[:style]),
                 call_method(obj2, data[:style]))
  end

  test "*a, b" do
    klass = Class.new do
      def call(*a, b)
        [a, b]
      end
    end
    obj1 = klass.new
    obj2 = klass.new
    proxy.mock(obj2).call.with_any_args
    assert_equal(call_method(obj1, data[:style]),
                 call_method(obj2, data[:style]))
  end
end
