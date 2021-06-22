class TestMockProxyKwargs < Test::Unit::TestCase
  class C
    def m1(a, b)
      [a, b]
    end

    def m2(a, **b)
      [a, b]
    end

    def m3(*a)
      [a]
    end

    def m4(*a, **b)
      [a, b]
    end

    def m5(a, *b)
      [a, b]
    end

    def m6(*a, b)
      [a, b]
    end
  end

  setup do
    @obj1 = C.new
    @obj2 = C.new
  end

  prefix = { req: '', rest: '*', keyrest: '**' }
  %i[m1 m2 m3 m4 m5 m6].each do |method|
    sig = C.instance_method(method).parameters
      .map { |t, n| "#{prefix[t]}#{n}" }
      .join(', ')
    data(:args, ['1, a: 2', '1, { a: 2 }', '1, **{ a: 2 }'])
    test "#{method}(#{sig})" do
      eval("proxy.mock(@obj2).#{method}.with_any_args", binding, __FILE__, __LINE__)

      val1, val2 = %w[obj1 obj2].map do |var|
        eval("@#{var}.#{method}(#{data[:args]})", binding, __FILE__, __LINE__)
      rescue => e
        { class: e.class, message: e.message }
      end

      assert_equal(val1, val2)
    end
  end
end
