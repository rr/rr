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


## Learning more

1. [What is a test double?](doc/01_test_double.md)
2. [Using RR with your test framework](doc/02_test_framework_integration.md)
3. [Syntax between RR and other double/mock frameworks](doc/03_syntax_comparison.md)
4. [API overview](doc/04_api_overview.md)


## Contributing

Want to contribute a bugfix or new feature to RR? Great! Follow these steps:

1. Clone the repo (you probably knew that already).
2. Make a new branch off of `master` with a descriptive name.
3. Work on your bugfix or feature.
4. Run `bundle install`
5. Ensure all of the tests pass by running `rake`.
6. If you want to go the extra mile, repeat steps 4-6 on all of the Ruby
   versions listed below.
7. When you're done, go to GitHub and create a pull request from your branch.
   I'll get to it as soon as I can.


## Compatibility

RR is designed and tested to work against the following test frameworks and Ruby
versions:

|                       | Ruby 1.8.7-p371 | Ruby 1.9.3-p392 | Ruby 2.0.0-p0 | JRuby 1.7.3 (1.9 mode) |
|-----------------------|:---------------:|:---------------:|:-------------:|:----------------------:|
| MiniTest >= 4.7.3     |   | ✓ | ✓ | ✓ |
| Test::Unit (Ruby 1.8) | ✓ |   |   |   |
| Test::Unit >= 2.5.4   | ✓ | ✓ | ✓ | ✓ |
| RSpec 1.3.2           | ✓ |   |   |   |
| RSpec >= 2.13.0       |   | ✓ | ✓ | ✓ |


## Author/Contact

RR was originally written by Brian Takita. It is currently maintained by Elliot
Winkler (<elliot.winkler@gmail.com>).


## Acknowledgements

With any development effort, there are countless people who have contributed to
making it possible. We all are standing on the shoulders of giants. If you have
directly contributed to RR and I missed you in this list, please let me know and
I will add you. Thanks!

* Andreas Haller for patches
* Aslak Hellesoy for developing RSpec
* Bryan Helmkamp for patches
* Caleb Spare for patches
* Christopher Redinger for patches
* Dan North for syntax ideas
* Dave Astels for some BDD inspiration
* Dave Myron for a bug report
* David Chelimsky for encouragement to make the RR framework, for developing the
  RSpec mock framework, syntax ideas, and patches
* Daniel Sudol for identifing performance issues with RR
* Dmitry Ratnikov for patches
* Eugene Pimenov for patches
* Evan Phoenix for patches
* Felix Morio for pairing with me
* Gabriel Horner for patches
* Gavin Miller for patches
* Gerard Meszaros for his excellent book "xUnit Test Patterns"
* James Mead for developing Mocha
* Jeff Whitmire for documentation suggestions
* Jim Weirich for developing Flexmock, the first terse ruby mock framework in
  Ruby
* Joe Ferris for patches
* Matthew O'Connor for patches and pairing with me
* Michael Niessner for patches and pairing with me
* Mike Mangino (from Elevated Rails) for patches and pairing with me
* Myron Marston for bug reports
* Nick Kallen for documentation suggestions, bug reports, and patches
* Nathan Sobo for various ideas and inspiration for cleaner and more expressive
  code
* Parker Thompson for pairing with me
* Phil Darnowsky for patches
* Pivotal Labs for sponsoring RR development
* Steven Baker for developing RSpec
* Tatsuya Ono for patches
* Tuomas Kareinen for a bug report

