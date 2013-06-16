ruby_18_stuff = proc do
  ruby_18_test_unit_2 = proc do
    gem 'test-unit', '~> 2.4.0'
  end

  ruby_18_rails_2 = proc do
    gem 'rails', '~> 2.3'
    gem 'activesupport', '~> 2.3'
    gem 'activerecord', '~> 2.3'
    gem 'mocha', '~> 0.12.0'
    gem 'sqlite3', '~> 1.3', :platforms => :ruby
    gem 'activerecord-jdbcsqlite3-adapter', :platforms => :jruby
  end

  ruby_18_rspec_1 = proc do
    gem 'rspec', '~> 1.3'
  end

  #---

  appraise 'ruby_18_test_unit_1' do
  end

  appraise 'ruby_18_test_unit_1_rails_2' do
    instance_eval &ruby_18_rails_2
  end

  appraise 'ruby_18_test_unit_2' do
    instance_eval &ruby_18_test_unit_2
  end

  appraise 'ruby_18_test_unit_2_rails_2' do
    instance_eval &ruby_18_test_unit_2
    instance_eval &ruby_18_rails_2
  end

  appraise 'ruby_18_rspec_1' do
    instance_eval &ruby_18_rspec_1
  end

  appraise 'ruby_18_rspec_1_rails_2' do
    instance_eval &ruby_18_rspec_1
    instance_eval &ruby_18_rails_2
  end
end

ruby_19_stuff = proc do
  ruby_19_test_unit_2 = proc do
    gem 'test-unit', '~> 2.5'
  end

  ruby_19_minitest_4 = proc do
    gem 'minitest', "~> 4.7"
  end

  ruby_19_minitest = proc do
    gem 'minitest', "~> 5.0"
  end

  ruby_19_rails_3 = proc do
    gem 'railties', '~> 3.0'
    gem 'activesupport', '~> 3.0'
    gem 'activerecord', '~> 3.0'
    gem 'sqlite3', '~> 1.3', :platforms => :ruby
    gem 'activerecord-jdbcsqlite3-adapter', :platforms => :jruby
  end

  ruby_19_rails_4 = proc do
    gem 'railties', '4.0.0.rc1'
    gem 'activesupport', '4.0.0.rc1'
    gem 'activerecord', '4.0.0.rc1'
    gem 'rspec-rails', '~> 2.0'
    gem 'sqlite3', '~> 1.3', :platforms => :ruby
    gem 'activerecord-jdbcsqlite3-adapter', :platforms => :jruby
  end

  ruby_19_rspec_2 = proc do
    gem "rspec", "~> 2.13"
  end

  #---

  appraise 'ruby_19_test_unit_200' do
  end

  appraise 'ruby_19_test_unit_200_rails_3' do
    instance_eval &ruby_19_rails_3
  end

  appraise 'ruby_19_test_unit_200_rails_4' do
    instance_eval &ruby_19_rails_4
  end

  appraise 'ruby_19_test_unit_2' do
    instance_eval &ruby_19_test_unit_2
  end

  appraise 'ruby_19_test_unit_2_rails_3' do
    instance_eval &ruby_19_test_unit_2
    instance_eval &ruby_19_rails_3
  end

  appraise 'ruby_19_test_unit_2_rails_4' do
    instance_eval &ruby_19_test_unit_2
    instance_eval &ruby_19_rails_4
  end

  appraise 'ruby_19_minitest_4' do
    instance_eval &ruby_19_minitest_4
  end

  appraise 'ruby_19_minitest_4_rails_3' do
    instance_eval &ruby_19_minitest_4
    instance_eval &ruby_19_rails_3
  end

  appraise 'ruby_19_minitest_4_rails_4' do
    instance_eval &ruby_19_minitest_4
    instance_eval &ruby_19_rails_4
  end

  appraise 'ruby_19_minitest' do
    instance_eval &ruby_19_minitest
  end

  appraise 'ruby_19_minitest_rails_3' do
    instance_eval &ruby_19_minitest
    instance_eval &ruby_19_rails_3
  end

  appraise 'ruby_19_rspec_2' do
    instance_eval &ruby_19_rspec_2
  end

  appraise 'ruby_19_rspec_2_rails_3' do
    instance_eval &ruby_19_rspec_2
    instance_eval &ruby_19_rails_3
  end

  appraise 'ruby_19_rspec_2_rails_4' do
    instance_eval &ruby_19_rspec_2
    instance_eval &ruby_19_rails_4
  end
end

if RUBY_VERSION =~ /^1\.8/
  instance_eval &ruby_18_stuff
else
  instance_eval &ruby_19_stuff
end
