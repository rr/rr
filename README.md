# RR [![Build Status](https://secure.travis-ci.org/rr/rr.png)](http://travis-ci.org/rr/rr)

RR is a test double framework for Ruby that features a rich selection of double
techniques and a terse syntax.


## Getting started

Simply add the following to your Gemfile:

~~~ ruby
gem 'rr', '~> 1.0.5'
~~~

If you're on Rails, make sure to add it to the "test" group:

~~~ ruby
group :test do
  gem 'rr', '~> 1.0.5'
end
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

### Stubs

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
2. [Using RR with your test framework](doc/02_test_framework_integration.md)
3. [Syntax between RR and other double/mock frameworks](doc/03_syntax_comparison.md)
4. [API overview](doc/04_api_overview.md)


## Help

RR does not have a mailing at this present time, so if you have a question
simply [post it as an issue](http://github.com/rr/rr/issues). I'll respond as
soon as I can.


## Contributing

Want to contribute a bugfix or new feature to RR? Great! Follow these steps:

1. Clone the repo (you probably knew that already).
2. Make a new branch off of `master` with a descriptive name.
3. Work on your bugfix or feature.
4. Run `bundle install`
5. Ensure all of the tests pass by running `rake`.
6. If you want to go the extra mile, repeat steps 4-6 on all of the Ruby
   versions listed below.
7. When you're done, come back to this repo and create a pull request from your
   branch. I'll respond as soon as I can.


## Compatibility

RR is designed and tested to work against the following test frameworks and Ruby
versions:

|                       | Ruby 1.8.7-p371 | Ruby 1.9.3-p392 | Ruby 2.0.0-p0 | JRuby 1.7.3 (1.9 mode) |
|-----------------------|:---------------:|:---------------:|:-------------:|:----------------------:|
| MiniTest 4.x                      |   | ✓ | ✓ | ✓ |
| Test::Unit (Ruby 1.8)             | ✓ |   |   |   |
| Test::Unit (Ruby 1.8) + Rails 2.x | ✓ |   |   |   |
| Test::Unit 2.x                    | ✓ | ✓ | ✓ | ✓ |
| Test::Unit 2.x + Rails 2.x        | ✓ |   |   |   |
| Test::Unit 2.x + Rails 3.x        |   | ✓ | ✓ | ✓ |
| RSpec 1.x                         | ✓ |   |   |   |
| RSpec 2.x                         |   | ✓ | ✓ | ✓ |


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
