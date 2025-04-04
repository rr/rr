# -*- ruby -*-

source "https://rubygems.org"

gemspec

group :development, :test do
  gem("bundler")
  gem("rake")

  case ENV["RR_INTEGRATION"]
  when "minitest"
    gem("minitest")
  when "minitest-active-support"
    gem("activesupport")
  end
end

group :test do
  gem("test-unit")
  gem("test-unit-rr")
end
