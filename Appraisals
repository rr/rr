ruby_18_stuff = proc do
  ruby_18_rails_2 = proc do
    gem 'rails', '~> 2.3'
    gem 'mocha', '~> 0.12.0'
    gem 'sqlite3', '~> 1.3', :platforms => :ruby
    gem 'activerecord-jdbcsqlite3-adapter', :platforms => :jruby
  end

  #---

  appraise 'ruby_18_rspec_1' do
  end

  appraise 'ruby_18_rspec_1_rails_2' do
    instance_eval &ruby_18_rails_2
  end
end

ruby_19_stuff = proc do
  ruby_19_rails_3 = proc do
    gem 'rails', '~> 3.0'
  end

  ruby_19_rails_4 = proc do
    gem 'rails', '4.0.0'
  end

  #---

  appraise 'ruby_19_rspec_2' do
  end

  appraise 'ruby_19_rspec_2_rails_3' do
    instance_eval &ruby_19_rails_3
  end

  appraise 'ruby_19_rspec_2_rails_4' do
    instance_eval &ruby_19_rails_4
  end
end

if RUBY_VERSION =~ /^1\.8/
  instance_eval &ruby_18_stuff
else
  instance_eval &ruby_19_stuff
end
