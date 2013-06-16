# RR [![Build Status](https://secure.travis-ci.org/rr/rr.png)](http://travis-ci.org/rr/rr) [![Code Climate GPA](https://codeclimate.com/github/rr/rr.png)](https://codeclimate.com/github/rr/rr)

RR is a test double framework for Ruby that features a rich selection of double
techniques and a terse syntax.


## Installing RR into your project

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


## Learning more

1. [What is a test double?](doc/01_test_double.md)
2. [Syntax between RR and other double/mock frameworks](doc/02_syntax_comparison.md)
3. [API overview](doc/03_api_overview.md)


## Help!

While I may add one later, RR does not have a mailing list at this time, so if
you have a question simply [post it as an issue](http://github.com/rr/rr/issues)
and I'll respond as soon as I can.


## Contributing

Want to contribute a bugfix or new feature to RR? Great! Follow these steps:

1. If you haven't already, install Ruby 2.0.0-p0 (this is the primary Ruby
   version that RR targets).
2. Clone the repo (you probably knew that already).
3. Make a new branch off of `master` with a descriptive name.
4. Work on your bugfix or feature.
5. Run `bundle install`.
6. Ensure all of the tests pass by running `bundle exec rake`.
7. If you want to go the extra mile, install the other Ruby versions listed
   below in the compatibility table, and repeat steps 5-6. See the "Running test
   suites" section below for more information.
8. When you're done, come back to this repo and create a pull request from your
   branch. I'll respond as soon as I can.

### Running test suites

In order to test support for multiple Ruby versions and environments, there are
multiple test suites, and Rake tasks to run these suites. The list of available
Rake tasks depends on which version of Ruby you are under, but you can get the
full list with:

    rake -D spec:

To run all the suites, simply say:

    rake

(Incidentally, this is also the command which Travis runs.)

Finally, to aid development only, if you're using rbenv, you can run all of the
tests on all of the Rubies easily with:

    script/run_full_test_suite

This requires that you have the
[rbenv-only](https://github.com/rodreegez/rbenv-only) plugin installed, and of
course, the necessary Rubies as well too.


## Compatibility

RR is designed and tested to work against the following test frameworks and
Ruby/Rails versions:

|                       | Ruby 1.8.7-p371 | Ruby 1.9.3-p392 | Ruby 2.0.0-p0 | JRuby 1.7.3 (1.9 mode) |
|-----------------------|:---------------:|:---------------:|:-------------:|:----------------------:|
| MiniTest 4.x                        |   | ✓ | ✓ | ✓ |
| MiniTest 4.x + Rails 3              |   | ✓ | ✓ | ✓ |
| MiniTest 4.x + Rails 4.0.0.rc1      |   | ✓ | ✓ | ✓ |
| Minitest 5.x                        |   | ✓ | ✓ | ✓ |
| Minitest 5.x + Rails 3              |   | ✓ | ✓ | ✓ |
| Test::Unit 1                        | ✓ |   |   |   |
| Test::Unit 1 + Rails 2.x            | ✓ |   |   |   |
| Test::Unit 2.0.0                    |   | ✓ | ✓ | ✓ |
| Test::Unit 2.0.0 + Rails 3.x        |   | ✓ | ✓ | ✓ |
| Test::Unit 2.0.0 + Rails 4.0.0.rc1  |   | ✓ | ✓ | ✓ |
| Test::Unit 2.4.x                    | ✓ |   |   |   |
| Test::Unit 2.4.x + Rails 2.x        | ✓ |   |   |   |
| Test::Unit ~> 2.5                   |   | ✓ | ✓ | ✓ |
| Test::Unit ~> 2.5 + Rails 3.x       |   | ✓ | ✓ | ✓ |
| Test::Unit ~> 2.5 + Rails 4.0.0.rc1 |   | ✓ | ✓ | ✓ |
| RSpec 1.x                           | ✓ |   |   |   |
| RSpec 1.x + Rails 2.x               | ✓ |   |   |   |
| RSpec 2.x                           |   | ✓ | ✓ | ✓ |
| RSpec 2.x + Rails 3.x               |   | ✓ | ✓ | ✓ |
| RSpec 2.x + Rails 4.0.0.rc1         |   | ✓ | ✓ | ✓ |


## Author/Contact

RR was originally written by Brian Takita. It is currently maintained by Elliot
Winkler (<elliot.winkler@gmail.com>).


## Credits

With any development effort, there are countless people who have contributed to
making it possible. We all are standing on the shoulders of giants! [You can
read all the credits here](CREDITS.md). (Incidentally, if you've directly
contributed to RR and I haven't included you in this list, please let me know.
Thanks!)


## License

RR is available under the MIT license. Read [LICENSE](LICENSE) for the full
scoop.
