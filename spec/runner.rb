require 'session'

class SuitesRunner
  TEST_SUITES = [
    [:rspec_1, 'RSpec', 'RSpec 1'],
    [:rspec_2, 'RSpec', 'RSpec 2'],
    [:test_unit_1, 'TestUnit', 'Test::Unit'],
    [:test_unit_2, 'TestUnit', 'Test::Unit'],
    [:minitest, 'Minitest', 'MiniTest']
  ]

  attr_reader :bash

  def initialize
    @bash = Session::Bash.new
  end

  def run
    TEST_SUITES.each_with_index do |(path, class_fragment, desc), i|
      puts "----------------" unless i == 0
      run_examples(path, class_fragment, desc)
      puts
    end
  end

  def run_examples(path, class_fragment, desc)
    path = File.expand_path("../suites/#{path}/runner.rb", __FILE__)
    # From http://www.eglug.org/node/946
    bash.execute "exec 3>&1", :out => STDOUT, :err => STDERR
    # XXX: why are we checking for this warning here...
    bash.execute "ruby -W #{path} 2>&1 >&3 3>&- | grep -v 'warning: useless use of' 3>&-; STATUS=${PIPESTATUS[0]}", :out => STDOUT, :err => STDERR
    status = bash.execute("echo $STATUS")[0].to_s.strip.to_i
    bash.execute "exec 3>&-", :out => STDOUT, :err => STDERR
    unless status == 0
      raise "#{desc} Suite Failed"
    end
  end
end

if $0 == __FILE__
  SuitesRunner.new.run
end

