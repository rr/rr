ruby_18_stuff = proc do
  ruby_18_test_unit_2 = proc do
    gem 'test-unit', '~> 2.4.0'
  end

  ruby_18_active_support = proc do
    gem 'rails', '~> 2.3'
    gem 'activesupport', '~> 2.3'
    gem 'activerecord', '~> 2.3'
    gem 'mocha', '~> 0.12.0'
  end

  ruby_18_rspec_1 = proc do
    gem 'rspec', '~> 1.3'
  end

  appraise 'ruby_18_test_unit_1' do
  end

  appraise 'ruby_18_test_unit_1_active_support' do
    instance_eval &ruby_18_active_support
  end

  appraise 'ruby_18_test_unit_2' do
    instance_eval &ruby_18_test_unit_2
  end

  appraise 'ruby_18_test_unit_2_active_support' do
    instance_eval &ruby_18_test_unit_2
    instance_eval &ruby_18_active_support
  end

  appraise 'ruby_18_rspec_1' do
    instance_eval &ruby_18_rspec_1
  end

  appraise 'ruby_18_rspec_1_active_support' do
    instance_eval &ruby_18_rspec_1
    instance_eval &ruby_18_active_support
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

  #---

  ruby_19_active_support = proc do
    gem 'railties', '~> 3.0'
    gem 'activesupport', '~> 3.0'
    gem 'activerecord', '~> 3.0'
  end

  ruby_19_rspec_2 = proc do
    gem "rspec", "~> 2.13"
  end

  appraise 'ruby_19_test_unit_2' do
    instance_eval &ruby_19_test_unit_2
  end

  appraise 'ruby_19_test_unit_2_active_support' do
    instance_eval &ruby_19_test_unit_2
    instance_eval &ruby_19_active_support
  end

  appraise 'ruby_19_minitest_4' do
    instance_eval &ruby_19_minitest_4
  end

  appraise 'ruby_19_minitest_4_active_support' do
    instance_eval &ruby_19_minitest_4
    instance_eval &ruby_19_active_support
  end

  appraise 'ruby_19_minitest' do
    instance_eval &ruby_19_minitest
  end

  appraise 'ruby_19_minitest_active_support' do
    instance_eval &ruby_19_minitest
    instance_eval &ruby_19_active_support
  end

  appraise 'ruby_19_rspec_2' do
    instance_eval &ruby_19_rspec_2
  end

  appraise 'ruby_19_rspec_2_active_support' do
    instance_eval &ruby_19_rspec_2
    instance_eval &ruby_19_active_support
  end
end

if RUBY_VERSION =~ /^1\.8/
  instance_eval &ruby_18_stuff
else
  instance_eval &ruby_19_stuff
end
