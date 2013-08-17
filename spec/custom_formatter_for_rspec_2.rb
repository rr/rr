require 'rspec/core/formatters/base_text_formatter'

class CustomFormatterForRSpec2 < RSpec::Core::Formatters::BaseTextFormatter
  def example_passed(example)
    super(example)
    output.puts passed_output(example)
    output.flush
  end

  def example_pending(example)
    super(example)
    output.puts pending_output(example, example.execution_result[:pending_message])
    output.flush
  end

  def example_failed(example)
    super(example)
    output.puts failure_output(example, example.execution_result[:exception])
    output.flush
  end

  private

  def passed_output(example)
    success_color("#{example.full_description.strip}")
  end

  def pending_output(example, message)
    pending_color("#{example.full_description.strip} (PENDING: #{message})")
  end

  def failure_output(example, exception)
    failure_color("#{example.full_description.strip} (FAILED - #{next_failure_index})")
  end

  def next_failure_index
    @next_failure_index ||= 0
    @next_failure_index += 1
  end
end
