require 'spec/runner/formatter/specdoc_formatter'

class CustomFormatterForRSpec < Spec::Runner::Formatter::SpecdocFormatter
  def example_passed(example)
    super
    output.flush
  end

  def example_pending(example, message)
    super
    output.flush
  end

  def example_failed(example, counter, failure)
    super
    output.flush
  end
end
