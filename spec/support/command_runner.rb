require 'open3'

class CommandRunner
  # http://stackoverflow.com/questions/6407141/how-can-i-have-ruby-logger-log-output-to-stdout-as-well-as-file
  class MultiIO
    def initialize(*targets)
       @targets = targets
    end

    def write(*args)
      @targets.each {|t| t.write(*args) }
    end
    alias_method :<<, :write

    def close
      @targets.each(&:close)
    end
  end

  def self.call(command, options={})
    new(command, options).call
  end

  attr_reader :command, :output, :exit_status

  def initialize(command, options)
    @command = command
    #@command << " 2>&1" unless @command =~ / 2>&1$/
    @output = ""
  end

  def call
    @stdout_buffer = StringIO.new

    puts "Running: #{@command}"

    if defined?(JRUBY_VERSION)
      call_using_popen4
    else
      call_using_spawn
    end

    if RR.debug?
      puts "~ Output from `#{@command}` ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts @output
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    end

    self
  end

  def success?
    @exit_status == 0
  end

  private

  def call_using_session
    reader, writer = IO.pipe
    require 'session'
    session = Session::Bash.new
    session.execute(@command, :stdout => writer, :stderr => writer)
    writer.close
    @exit_status = session.exit_status
    @output = reader.read
  end

  def call_using_popen4
    reader, writer = IO.pipe

    # Using popen4 here without a block will always result in an Errno::ECHILD
    # error under JRuby: <http://jira.codehaus.org/browse/JRUBY-5684>
    block = lambda { |pid, _, stdout, _| writer.write(stdout.read) }

    if defined?(JRUBY_VERSION)
      IO.popen4("#{@command} 2>&1", &block)
    else
      require 'open4'
      Open4.popen4("#{@command} 2>&1", &block)
    end

    writer.close
    @exit_status = $?.exitstatus
    @output = reader.read
  end

  def call_using_spawn
    reader, writer = IO.pipe
    args = [@command, {[:out, :err] => writer}]
    require 'posix-spawn'
    pid = POSIX::Spawn.spawn(*args)
    Process.waitpid(pid)
    writer.close
    @exit_status = $?.exitstatus
    @output = reader.read
  end

  def build_stdout
    ios = [@stdout_buffer]
    #if RR.debug?
    #  ios << $stdout
    #end
    MultiIO.new(*ios)
  end
end
