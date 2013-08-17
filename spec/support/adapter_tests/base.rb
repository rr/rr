require 'set'

module AdapterTests
  module Base
    private

    def assert_stubs_work
      subject = Object.new
      stub(subject).foobar { :baz }
      assert_equal :baz, subject.foobar("any", "thing")
    end

    def assert_mocks_work
      subject = Object.new
      mock(subject).foobar(1, 2) { :baz }
      assert_equal :baz, subject.foobar(1, 2)
    end

    def assert_stub_proxies_work
      subject = Object.new
      def subject.foobar; :baz; end
      stub.proxy(subject).foobar
      assert_equal :baz, subject.foobar
    end

    def assert_mock_proxies_work
      subject = Object.new
      def subject.foobar; :baz; end
      mock.proxy(subject).foobar
      assert_equal :baz, subject.foobar
    end

    def assert_times_called_verifications_work
      subject = Object.new
      mock(subject).foobar(1, 2) { :baz }
      assert_raises RR::Errors.error_class(:TimesCalledError) do
        RR.verify
      end
    end

    def assert_adapters_loaded(matching_adapters)
      assert_subset Set.new(matching_adapters), Set.new(RR.loaded_adapter_names)
    end
  end
end
