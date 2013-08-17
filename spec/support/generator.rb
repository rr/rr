module Generator
  module ClassMethods
    attr_reader :configurators

    def factory
      klass = Class.new(self)
      yield klass if block_given?
      klass
    end

    def call(*args, &block)
      new(*args, &block).tap { |object| object.call }
    end

    def generate(&block)
      factory.call(&block)
    end

    def mixin(mod)
      include mod
    end

    def configure(&block)
      configurators << block
    end

    def configurators
      @configurators ||= []
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  def initialize(*args)
    setup(*args)
    run_configurators
    configure(*args)
    yield self if block_given?
  end

  def setup(*args)
  end

  def configure(*args)
  end

  private

  def run_configurators
    self.class.configurators.each do |configurator|
      configurator.call(self)
    end
  end
end
