require File.expand_path('../base', __FILE__)
require File.expand_path('../../project/rails', __FILE__)

module IntegrationTests
  module Rails
    class LeaveDatabaseTableClearMatcher < Struct.new(:project, :table_name)
      def matches?(block)
        @old_number_of_rows = number_of_rows
        block.call
        @new_number_of_rows = number_of_rows
        @old_number_of_rows == 0 && @new_number_of_rows == 0
      end

      def description
        "leave the database table #{table_name} unchanged"
      end

      def failure_message_for_should
        "Expected for database table #{table_name} to have been left clear, but it was changed (there are now #{@new_number_of_rows} rows)"
      end

      def failure_message_for_should_not
        "Expected for database table #{table_name} to not have been left clear, but it was"
      end

      private

      def number_of_rows
        result = project.exec!("echo 'select count(*) from #{table_name};' | sqlite3 #{project.database_file_path}")
        result.output.chomp.to_i
      end
    end

    include Base

    def configure_project_generator(project_generator)
      super
      configure_rails_project_generator(project_generator)
    end

    def build_rails_project_generator
      Project::Generator.factory do |project_generator|
        configure_rails_project_generator(project_generator)
        yield project_generator if block_given?
      end
    end

    def generate_rails_project(&block)
      build_rails_project_generator.call(&block)
    end

    def configure_rails_project_generator(project_generator)
      project_generator.mixin Project::Rails
    end

    def leave_database_table_clear(project, table_name)
      LeaveDatabaseTableClearMatcher.new(project, table_name)
    end
  end
end
