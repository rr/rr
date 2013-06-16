$is_java = (RUBY_PLATFORM == 'java')
if $is_java
  require 'active_record'
  require 'arjdbc'
  require 'arjdbc/sqlite3'
else
  require 'sqlite3'
end

module RailsIntegrationTests
  def sqlite_adapter
    $is_java ? 'jdbcsqlite3' : 'sqlite3'
  end

  def sqlite_db_file_path
    '/tmp/rr-test-db.sqlite3'
  end

  def rails_test_helper
    ruby_18? ? 'test_help' : 'rails/test_help'
  end

  def with_active_record_bootstrap(str)
    with_bootstrap str, :before_require_test_framework => <<-EOT
      require 'active_record'

      # This is necessary to turn on transactional tests, for some reason
      config = ActiveRecord::Base.configurations[:foo] = {
        :adapter => '#{sqlite_adapter}',
        :database => '#{sqlite_db_file_path}'
      }
      ActiveRecord::Base.establish_connection(config)

      require '#{rails_test_helper}'

      ActiveRecord::Base.logger = Logger.new(File.open('/tmp/tests.log', 'a+'))
      class Person < ActiveRecord::Base; end
    EOT
  end

  def database_properly_rolled_back_test
    with_active_record_bootstrap <<-EOT
      class FooTest < ActiveRecord::TestCase
        def test_one
          Person.create!(:name => 'Joe Blow')
          object = Object.new
          mock(object).foo
        end
      end
    EOT
  end

  def activerecord_teardown_still_works_test
    with_active_record_bootstrap <<-EOT
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

  def self.included(base)
    base.class_eval do
      specify "the database is properly rolled back after an RR error" do
        setup_database

        count = ActiveRecord::Base.connection.select_value('SELECT COUNT(*) from people')
        count.to_i.should be == 0

        run_fixture_tests(database_properly_rolled_back_test)

        count = ActiveRecord::Base.connection.select_value('SELECT COUNT(*) from people')
        count.to_i.should be == 0
      end

      specify "throwing an error in teardown doesn't mess things up" do
        setup_database
        run_fixture_tests(activerecord_teardown_still_works_test)
      end

      def setup_database
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
      end
    end
  end
end
