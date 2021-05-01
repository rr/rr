# RR [![Gem Version](https://badge.fury.io/rb/rr.svg)](https://badge.fury.io/rb/rr) [![Build Status](https://travis-ci.org/rr/rr.svg?branch=master)](https://travis-ci.org/rr/rr) [![Code Climate GPA](https://codeclimate.com/github/rr/rr.svg)](https://codeclimate.com/github/rr/rr)

RR is a test double framework for Ruby that features a rich selection of double
techniques and a terse syntax.

---

## Learning more

1. [A whirlwind tour of RR](#a-whirlwind-tour-of-rr)
2. [What is a test double?](doc/01_test_double.md)
3. [Syntax between RR and other double/mock frameworks](doc/02_syntax_comparison.md)
4. [API overview - Full listing of DSL methods](doc/03_api_overview.md)


## A whirlwind tour of RR

### Stubs

~~~ ruby
# Stub a method to return nothing
stub(object).foo
stub(MyClass).foo

# Stub a method to always return a value
stub(object).foo { 'bar' }
stub(MyClass).foo { 'bar' }

# Stub a method to return a value when called with certain arguments
stub(object).foo(1, 2) { 'bar' }
stub(MyClass).foo(1, 2) { 'bar' }
~~~

### Mocks

~~~ ruby
# Create an expectation on a method
mock(object).foo
mock(MyClass).foo

# Create an expectation on a method and stub it to always return a value
mock(object).foo { 'bar' }
mock(MyClass).foo { 'bar' }

# Create an expectation on a method with certain arguments and stub it to return
# a value when called that way
mock(object).foo(1, 2) { 'bar' }
mock(MyClass).foo(1, 2) { 'bar' }
~~~

### Spies

~~~ ruby
# RSpec
stub(object).foo
expect(object).to have_received.foo

# Test::Unit
stub(object).foo
assert_received(object) {|o| o.foo }
~~~

### Proxies

~~~ ruby
# Intercept a existing method without completely overriding it, and create a
# new return value from the existing one
stub.proxy(object).foo {|str| str.upcase }
stub.proxy(MyClass).foo {|str| str.upcase }

# Do the same thing except also create an expectation
mock.proxy(object).foo {|str| str.upcase }
mock.proxy(MyClass).foo {|str| str.upcase }

# Intercept a class's new method and define a double on the return value
stub.proxy(MyClass).new {|obj| stub(obj).foo; obj }

# Do the same thing except also create an expectation on .new
mock.proxy(MyClass).new {|obj| stub(obj).foo; obj }
~~~

### Class instances

~~~ ruby
# Stub a method on an instance of MyClass when it is created
any_instance_of(MyClass) do |klass|
  stub(klass).foo { 'bar' }
end

# Another way to do this which gives you access to the instance itself
stub.proxy(MyClass).new do |obj|
  stub(obj).foo { 'bar' }
end
~~~


## Installing RR into your project

NOTE: If you want to use RR with
[test-unit](https://test-unit.github.io/), use
[test-unit-rr](https://test-unit.github.io/#test-unit-rr). You don't
need to read the following subsections.

For minimal setup, RR looks for an existing test framework and then hooks itself
into it. Hence, RR works best when loaded *after* the test framework that you
are using is loaded.

If you are using Bundler, you can achieve this by specifying the dependency on
RR with `require: false`; then, require RR directly following your test
framework.

Here's what this looks like for different kinds of projects:

### Ruby project (without Bundler)

~~~ ruby
require 'your/test/framework'
require 'rr'
~~~

### Ruby project (with Bundler)

~~~ ruby
# Gemfile
gem 'rr', require: false

# test helper
require 'your/test/framework'
require 'rr'
~~~

### Rails project

~~~ ruby
# Gemfile
group :test do
  gem 'rr', require: false
end

# test helper
require File.expand_path('../../config/environment', __FILE__)
require 'your/test/framework'  # if you are using something other than MiniTest / Test::Unit
require 'rr'
~~~

## Compatibility

RR is designed and tested to work against the following Ruby versions:

* 2.4
* 2.5
* 2.6
* 2.7
* 3.0
* JRuby 1.7.4

as well as the following test frameworks:

* Test::Unit via [test-unit-rr](https://test-unit.github.io/#test-unit-rr)
* RSpec 2
* MiniTest 4
* Minitest 5

## Help!

If you have a question or are having trouble, simply [post it as an
issue](https://github.com/rr/rr/issues) and I'll respond as soon as I can.


## Contributing

Want to contribute a bug fix or new feature to RR? Great! Follow these steps:

1. Make sure you have a recent Ruby (check the compatibility table above).
2. Clone the repo (you probably knew that already).
3. Make a new branch off of `master` with a descriptive name.
4. Work on your patch.
5. Run `bundle install`.
6. Ensure all of the tests pass by running `bundle exec rake`.
7. If you want to go the extra mile, install the other Ruby versions listed
   above in the compatibility table, and repeat steps 5-6. See the "Running test
   suites" section below for more information.
8. When you're done, push your branch and create a pull request from it.
   I'll respond as soon as I can.

### Running tests

As indicated by the compatibility list above, in order to test support for
multiple Ruby versions and environments, there are multiple test suites, and
Rake tasks to run these suites. The list of available Rake tasks depends on
which version of Ruby you are under, but you can get the full list with:

    bundle exec rake -D spec:

To run all the suites, simply say:

    bundle exec rake

(Incidentally, this is also the command which Travis runs.)


## Author/Contact

RR was originally written by Brian Takita. And it was maintained by
Elliot Winkler (<elliot.winkler@gmail.com>). It is currently
maintained by Kouhei Sutou (<kou@cozmixng.org>).


## Credits

With any development effort, there are countless people who have contributed to
making it possible; RR is no exception! [You can read the full list of
credits here](CREDITS.md).


## License

RR is available under the [MIT license](LICENSE).
