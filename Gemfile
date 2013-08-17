source 'https://rubygems.org'

gem 'rake', '~> 10.0'
gem 'aws-sdk', '~> 1.0'
gem 'minitar', '~> 0.5'
gem 'dotenv', '~> 0.7'
gem 'simplecov', '~> 0.7'
gem 'appraisal', '~> 0.5'
gem 'posix-spawn', :platforms => :mri
gem 'open4', :platforms => :mri

# Put this here instead of in Appraisals so that when running a single test file
# in development we can say `rspec ...` or `spec ...` instead of having to
# prepend it with BUNDLE_GEMFILE=...
if RUBY_VERSION =~ /^1\.8/
  gem 'rspec', '~> 1.3'
else
  gem 'rspec', '~> 2.14'
end
