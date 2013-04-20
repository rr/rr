# Make sure to run this file with `bundle exec`

require 'rubygems'
require File.expand_path('../spec_helper', __FILE__)
require 'session'
require 'tempfile'
$is_java = (RUBY_PLATFORM == 'java')
if $is_java
  require 'arjdbc'
  require 'arjdbc/sqlite3'
else
  require 'sqlite3'
end

describe "Integration between TestUnit and Rails" do
  def debug?
    false
  end

  def run_fixture_tests(content)
    output = nil
    f = Tempfile.new('rr_test_fixture')
    f.write(content)
    f.close
    bash = Session::Bash.new
    cmd = "ruby #{f.path} 2>&1"
    puts cmd if debug?
    stdout, stderr = bash.execute(cmd)
    success = !!(bash.exit_status == 0 || stdout =~ /Finished/)
    if debug? or !success
      puts stdout
      puts stderr
    end
    success.should be_true
    stdout
  ensure
    f.unlink
  end

  def test_helper_path
    File.expand_path('../../../global_helper', __FILE__)
  end

  def sqlite_adapter
    $is_java ? 'jdbcsqlite3' : 'sqlite3'
  end

  def sqlite_db_file_path
    '/tmp/rr-test-db.sqlite3'
  end

  def bootstrap
    <<-EOT
      RAILS_ROOT = File.expand_path(__FILE__)
      require 'test/unit'

      require 'rubygems'
      require 'rack'
      require 'active_support/all'
      require 'action_controller'
      require 'active_support/test_case'
    EOT
  end

  def bootstrap_active_record
    <<-EOT
      #{bootstrap}

      require 'active_record'

      # This is necessary to turn on transactional tests, for some reason
      config = ActiveRecord::Base.configurations[:foo] = {
        :adapter => '#{sqlite_adapter}',
        :database => '#{sqlite_db_file_path}'
      }
      ActiveRecord::Base.establish_connection(config)

      require 'test_help'
    EOT
  end

  specify "when RR raises an error it raises a failure not an exception" do
    output = run_fixture_tests <<-EOT
      #{bootstrap}
      require "#{test_helper_path}"

      class FooTest < ActiveSupport::TestCase
        def test_one
          object = Object.new
          mock(object).foo
        end
      end
    EOT
    output.should match /Failure/
    output.should match /1 failures/
  end

  specify "the database is properly rolled back after an RR error" do
    require 'active_record'
    FileUtils.rm_f(sqlite_db_file_path)
    ActiveRecord::Base.establish_connection(
      :adapter => sqlite_adapter,
      :database => sqlite_db_file_path
    )
    unless debug?
      old_stdout = $stdout
      $stdout = File.open('/dev/null', 'w')
    end
    ActiveRecord::Migration.create_table :people do |t|
      t.string :name
    end
    unless debug?
      $stdout = old_stdout
    end

    count = ActiveRecord::Base.connection.select_value('SELECT COUNT(*) from people')
    count.to_i.should be == 0

    run_fixture_tests <<-EOT
      #{bootstrap_active_record}

      ActiveRecord::Base.logger = Logger.new(File.open('/tmp/tests.log', 'a+'))

      class Person < ActiveRecord::Base; end

      require "#{test_helper_path}"

      class FooTest < ActiveRecord::TestCase
        def test_one
          Person.create!(:name => 'Joe Blow')
          object = Object.new
          mock(object).foo
        end
      end
    EOT

    count = ActiveRecord::Base.connection.select_value('SELECT COUNT(*) from people')
    count.to_i.should be == 0
  end

  specify "throwing an error in teardown doesn't mess things up" do
    require 'active_record'
    FileUtils.rm_f(sqlite_db_file_path)
    ActiveRecord::Base.establish_connection(
      :adapter => sqlite_adapter,
      :database => sqlite_db_file_path
    )
    unless debug?
      old_stdout = $stdout
      $stdout = File.open('/dev/null', 'w')
    end
    ActiveRecord::Migration.create_table :people do |t|
      t.string :name
    end
    unless debug?
      $stdout = old_stdout
    end

    output = run_fixture_tests <<-EOT
      #{bootstrap_active_record}

      ActiveRecord::Base.logger = Logger.new(File.open('/tmp/tests.log', 'a+'))

      class Person < ActiveRecord::Base; end

      require "#{test_helper_path}"

      class FooTest < ActiveRecord::TestCase
        teardown do
          raise 'hell'
        end

        def test_one
          # whatever
        end
      end
    EOT
  end
end
