require File.expand_path('../../test_helper/generator', __FILE__)

module Project
  module Rails
    attr_accessor :rails_version

    def add_model_and_migration(model_name, table_name, attributes)
      model_class_name = model_name.to_s.capitalize
      symbolized_attribute_names = attributes.keys.map {|v| ":#{v}" }.join(', ')
      migration_timestamp = Time.now.strftime("%Y%m%d%H%M%S")
      camelized_table_name = table_name.to_s.capitalize
      migration_column_definitions = attributes.map do |name, type|
        "t.#{type} :#{name}"
      end.join("\n")

      model_content = "class #{model_class_name} < ActiveRecord::Base\n"
      if rails_version == 3
        model_content << "attr_accessible #{symbolized_attribute_names}\n"
      end
      model_content << "end\n"
      add_file "app/models/#{model_name}.rb", model_content

      add_file "db/migrate/#{migration_timestamp}_create_#{table_name}.rb", <<-EOT
        class Create#{camelized_table_name} < ActiveRecord::Migration
          def #{'self.' if rails_version == 2}up
            create_table :#{table_name} do |t|
              #{migration_column_definitions}
            end
          end

          def #{'self.' if rails_version == 2}down
            drop_table :#{table_name}
          end
        end
      EOT
    end

    def gem_dependency(dep)
      dep = dep.dup
      dep[:version] ||= '>= 0'
      groups = Array(dep[:group] || [])
      groups << :test unless groups.include?(:test)
      dep[:group] = groups
      dep
    end

    def sqlite_adapter
      under_jruby? ? 'jdbcsqlite3' : 'sqlite3'
    end

    def database_file_path
      File.join(directory, 'db/test.sqlite3')
    end

    def test_helper_generator
      @test_helper_generator ||= TestHelper::Generator.factory
    end

    private

    def generate_skeleton
      super

      create_rails_app

      within do
        if rails_version == 2
          add_bundler_support
          fix_obsolete_reference_to_rdoctask_in_rakefile
          monkeypatch_gem_source_index
        end

        if under_jruby? && rails_version == 4
          update_activerecord_jdbc_adapter_to_beta_version
        end

        declare_and_install_gems
        create_files
        configure_database
        run_migrations
      end
    end

    def create_rails_app
      # remember that this has to be run with `bundle exec` to catch the correct
      # 'rails' executable (rails 3 or rails 4)!
      run_command! create_rails_app_command, :without_bundler_sandbox => true
    end

    def create_rails_app_command
      command = 'rails'
      if rails_version == 2
        command << " #{directory}"
      else
        command << " new #{directory} --skip-bundle"
      end
      ruby_command(command)
    end

    def add_bundler_support
      create_file 'config/patch_bundler_into_rails_23.rb', <<'EOT'
class Rails::Boot
  def run
    load_initializer

    Rails::Initializer.class_eval do
      def load_gems
        @bundler_loaded ||= Bundler.require :default, Rails.env
      end
    end

    Rails::Initializer.run(:set_load_path)
  end
end
EOT

      add_in_file_before 'config/boot.rb', "Rails.boot!\n", <<-EOT
        load File.expand_path('../patch_bundler_into_rails_23.rb', __FILE__)
      EOT

      create_file 'config/preinitializer.rb', <<'EOT'
begin
  require 'rubygems'
  require 'bundler'
rescue LoadError
  raise "Could not load the bundler gem. Install it with `gem install bundler`."
end

if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.24")
  raise RuntimeError, "Your bundler version is too old for Rails 2.3.\n" +
   "Run `gem install bundler` to upgrade."
end

begin
  # Set up load paths for all bundled gems
  ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems.\n" +
    "Did you run `bundle install`?"
end
EOT

      create_file 'Gemfile', <<'EOT'
source 'https://rubygems.org'

gem 'rails', '~> 2.3.0'
gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'rdoc'
EOT
    end

    def monkeypatch_gem_source_index
      create_file 'config/rubygems_patch.rb',
        File.read(File.expand_path('../../../fixtures/rubygems_patch_for_187.rb', __FILE__)),
        :without_debug => true

      # http://djellemah.com/blog/2013/02/27/rails-23-with-ruby-20/
      add_in_file_before 'config/boot.rb', "Rails.boot!\n", <<-EOT
        Rails::GemBoot.module_eval do
          class << self
            alias :original_load_rubygems :load_rubygems
            def load_rubygems
              original_load_rubygems
              load File.expand_path('../rubygems_patch.rb', __FILE__)
            end
          end
        end
      EOT
    end

    def fix_obsolete_reference_to_rdoctask_in_rakefile
      replace_in_file 'Rakefile', 'rake/rdoctask', 'rdoc/task'
    end

    def update_activerecord_jdbc_adapter_to_beta_version
      # The latest version of activerecord-jdbcsqlite3-adapter is not quite
      # compatible with Rails 4 -- see:
      # <https://github.com/jruby/activerecord-jdbc-adapter/issues/253>
      replace_in_file 'Gemfile',
        "gem 'activerecord-jdbcsqlite3-adapter'\n",
        "gem 'activerecord-jdbcsqlite3-adapter', '1.3.0.beta2'\n"
    end

    def configure_database
      create_file 'config/database.yml', <<EOT
development: &development
  adapter: #{sqlite_adapter}
  database: #{database_file_path}
test:
  <<: *development
EOT
    end

    def run_migrations
      run_command_within! ruby_command('rake db:migrate --trace')
    end
  end
end
