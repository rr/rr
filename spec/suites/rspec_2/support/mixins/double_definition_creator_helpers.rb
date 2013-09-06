module DoubleDefinitionCreatorHelpers
  module ClassMethods
    def methods_being_doubled_exist_already?
      metadata[:methods_exist] || supports_proxying? || supports_mocking?
    end

    def type_of_methods_being_tested
      metadata[:method_type]
    end

    def supports_proxying?
      metadata[:is_proxy]
    end

    def supports_instance_of?
      metadata[:is_instance_of]
    end

    def supports_mocking?
      metadata[:is_mock]
    end

    def supports_strong?
      metadata[:is_strong]
    end

    def supports_dont_allow?
      metadata[:is_dont_allow]
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  def build_object_with_possible_methods(methods = {}, actually_add_methods = methods_being_doubled_exist_already?)
    subject =
      if type_of_methods_being_tested == :class
        Class.new
      else
        Object.new
      end

    if actually_add_methods
      if supports_instance_of?
        add_methods_to_class(subject, methods)
      else
        add_methods_to_class(subject.singleton_class, methods)
      end
    end

    object =
      if type_of_methods_being_tested == :class && supports_instance_of?
        subject.new
      else
        subject
      end

    if block_given?
      yield subject, object
    end

    object
  end

  def build_object_with_methods(methods = {}, &block)
    build_object_with_possible_methods(methods, true, &block)
  end
  alias_method :build_object, :build_object_with_methods

  def add_methods_to_class(klass, methods)
    klass.class_eval do
      methods.each do |method_name, implementation|
        implementation ||= ->(*args) { }
        define_method(method_name, &implementation)
      end
    end
  end

  def expect_method_to_have_value_or_be_absent(return_value, object, method_name, *args, &block)
    if methods_being_doubled_exist_already?
      expect(object.__send__(method_name, *args, &block)).to eq return_value
    else
      expect_method_to_not_exist(object, method_name)
    end
  end

  def expect_method_to_not_exist(object, method_name)
    expect { object.method_name }.to raise_error(NoMethodError)
    # Commenting this out for now since this is broken.
    # See: btakita/rr #43
    #expect(object).not_to respond_to(method_name)
  end

  def build_object_with_doubled_method_which_is_called(original_value, new_value=nil, opts={}, &define_double)
    method_name = :some_method

    object = build_object_with_methods(method_name => -> { original_value }) do |subject|
      double_creator = double_definition_creator_for(subject)

      if define_double
        define_double.call(double_creator, method_name, new_value)
      else
        double_creator.__send__(method_name)
      end
    end

    if opts[:before_method_call]
      opts[:before_method_call].call
    end

    return_value = object.__send__(method_name)
    [object, method_name, return_value]
  end

  def build_object_with_doubled_method_which_is_reset_and_called(original_value, new_value, opts={})
    opts = opts.merge(before_method_call: -> { RR.reset })
    build_object_with_doubled_method_which_is_called(original_value, new_value, opts)
  end

  def call_possible_method_on(object, method_name, *args, &block)
    object.__send__(method_name, *args, &block)
  rescue NoMethodError
  end

  def expect_call_to_return_or_raise_times_called_error(return_value, object, method_name, *args, &block)
    if supports_dont_allow?
      expect { object.__send__(method_name, *args, &block) }.
        to raise_error(RR::Errors::TimesCalledError)
    else
      expect(object.__send__(method_name, *args, &block)).to eq return_value
    end
  end

  def call_method_rescuing_times_called_error(object, method_name, *args, &block)
    if supports_dont_allow?
      begin
        object.__send__(method_name, *args, &block)
      rescue RR::Errors::TimesCalledError
      end
    else
      object.__send__(method_name, *args, &block)
    end
  end

  def methods_being_doubled_exist_already?
    self.class.methods_being_doubled_exist_already?
  end

  def type_of_methods_being_tested
    self.class.type_of_methods_being_tested
  end

  def supports_proxying?
    self.class.supports_proxying?
  end

  def supports_instance_of?
    self.class.supports_instance_of?
  end

  def supports_mocking?
    self.class.supports_mocking?
  end

  def supports_strong?
    self.class.supports_strong?
  end

  def supports_dont_allow?
    self.class.supports_dont_allow?
  end
end
