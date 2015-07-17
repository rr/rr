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

instance_eval &ruby_19_stuff
