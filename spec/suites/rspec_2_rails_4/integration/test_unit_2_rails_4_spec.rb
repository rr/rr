require File.expand_path('../../spec_helper', __FILE__)

describe 'Integration with Test::Unit >= 2.5 and Rails 4' do
  include IntegrationTests::RailsTestUnit

  def configure_rails_project_generator(project_generator)
    super
    project_generator.configure do |project|
      project.rails_version = 4
    end
  end

  def configure_project_generator(project_generator)
    super
    project_generator.configure do |project|
      project.test_unit_gem_version = '>= 2.5'
    end
  end

  def self.including_the_adapter_manually_works
    specify "including the adapter manually works" do
      project = generate_project do |project|
        project.add_to_prelude <<-EOT
          class ActiveSupport::TestCase
            include RR::Adapters::TestUnit
          end
        EOT
      end
      project.add_test_file do |file|
        file.add_working_test_case_with_adapter_tests do |test_case|
          test_case.add_to_body <<-EOT
            def test_the_correct_adapters_are_loaded
              assert_adapters_loaded #{adapters_that_should_be_loaded.inspect}
            end
          EOT
        end
      end
      result = project.run_tests
      result.should be_success
      result.should_not have_errors_or_failures
    end
  end

  def self.rr_hooks_into_the_test_framework_automatically
    specify "RR hooks into the test framework automatically" do
      project = generate_project
      project.add_test_file do |file|
        file.add_working_test_case
      end
      result = project.run_tests
      result.should be_success
      result.should_not have_errors_or_failures
    end
  end

  def self.using_rr_with_cucumber_works
    specify "using RR with Cucumber works" do
      pending "Cucumber doesn't work with Rails 4 just yet"
      project_generator = build_rails_project_generator do |project_generator|
        project_generator.mixin Project::Cucumber
      end
      project = project_generator.call
      result = project.run_command_within("bundle exec cucumber")
      result.should be_success
    end
  end

  context 'when Bundler is autorequiring RR' do
    def configure_project_generator(project_generator)
      super
      project_generator.configure do |project|
        project.autorequire_gems = true
      end
    end

    def adapters_that_should_be_loaded
      [:TestUnit2]
    end

    including_the_adapter_manually_works
    using_rr_with_cucumber_works
  end

  context 'when RR is being required manually' do
    def configure_project_generator(project_generator)
      super
      project_generator.configure do |project|
        project.autorequire_gems = false
      end
    end

    def adapters_that_should_be_loaded
      [:TestUnit2, :TestUnit2ActiveSupport]
    end

    rr_hooks_into_the_test_framework_automatically
    including_the_adapter_manually_works
    using_rr_with_cucumber_works

    specify "when RR raises an error it raises a failure not an exception" do
      project = generate_project
      project.add_test_file do |file|
        file.add_test_case do |test_case|
          test_case.add_test <<-EOT
            object = Object.new
            mock(object).foo
          EOT
        end
      end
      result = project.run_tests
      result.should fail_with_output(/1 failure/)
    end

    specify "the database is properly rolled back after an RR error" do
      project = generate_project do |project|
        project.add_model_and_migration(:person, :people, :name => :string)
      end
      project.add_test_file do |file|
        file.add_test_case do |test_case|
          test_case.add_test <<-EOT
            Person.create!(:name => 'Joe Blow')
            object = Object.new
            mock(object).foo
          EOT
        end
      end
      expect {
        result = project.run_tests
        result.should have_errors_or_failures
      }.to leave_database_table_clear(project, :people)
    end

    specify "throwing an error in teardown doesn't mess things up" do
      project = generate_project
      project.add_test_file do |file|
        file.add_test_case do |test_case|
          test_case.add_to_body <<-EOT
            def teardown
              raise 'hell'
            end
          EOT
          test_case.add_test("")   # doesn't matter
        end
      end
      result = project.run_tests
      result.should fail_with_output(/1 error/)
    end
  end
end
