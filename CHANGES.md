# Changelog

## 3.0.7 - 2021-08-17

### Fixes

  * Minitest + Active Support integration: Fixed a bug that `stub` in
    `setup {...}` is ignored.
    [GitHub#87][Reported by Boris]

### Thanks

  * Boris

## 3.0.6 - 2021-08-07

### Improvements

  * `assert_received`: Added support for keyword arguments.
    [GitHub#86][Reported by imadoki]

### Thanks

  * imadoki

## 3.0.5 - 2021-06-26

### Improvements

  * Improved keyword arguments support on Ruby 2.7.
    [GitHub#85][Patch by akira yamada]

### Thanks

  * akira yamada

## 3.0.4 - 2021-06-23

### Fixes

  * Fix inverted condition in keyword arguments related code.
    [GitHub#84][Patch by akira yamada]

### Thanks

  * akira yamada

## 3.0.3 - 2021-06-22

### Improvements

  * Improved keyword arguments support.
    [GitHub#83][Patch by akira yamada]

### Thanks

  * akira yamada

## 3.0.2 - 2021-06-18

### Improvements

  * `stub`: Added support for Ruby 3.0's keyword arguments.
    [GitHub#82][Reported by akira yamada]

### Thanks

  * akira yamada

## 3.0.1 - 2021-06-18

### Improvements

  * Suppressed keyword arguments related warnings on Ruby 2.7.
    [GitHub#81][Reported by akira yamada]

### Thanks

  * akira yamada

## 3.0.0 - 2021-03-31

### Improvements

  * Added support for Ruby 3.0's keyword arguments.
    [GitHub#17][Reported by Takuro Ashie]

### Fixes

  * Fixed a bug that `any_instance_of` doesn't work with class
    hierarchies. [GitHub#12][Reported by Étienne Barrié]

### Thanks

  * Étienne Barrié

  * Takuro Ashie

## 1.2.1 - 2017-06-22

### Fixes

  * Fixed a bug that `RR.reset` resets newly created methods.
    [GitHub#8]

## 1.2.0 - 2016-05-30

### Improvements

  * Renamed RR::Adapters::RRMethods to RR::DSL.

  * Deprecated RRMethods.

  * Updated document. [GitHub#57][Patch by Nikolay Shebanov]

  * Dropped Ruby 1.8 support.

  * Dropped Ruby 1.9 support.

  * Dropped Rails 3 support.

  * Dropped test-unit integration support. Use
    [test-unit-rr](https://test-unit.github.io/#test-unit-rr).

  * Supported OpenStruct in Ruby 2.3
    [GitHub#64][Reported by soylent][Reported by Arthur Le Maitre]

### Fixes

  * Fixed using RSpec's RR adapter to not override our RSpec adapter.
    If RR is required and then you use `mock_with :rr` you would not be able to
    use `have_received`.

  * Fixed a bug that `Hash` argument is too wild.
    [GitHub#54][Reported by Yutaka HARA]

  * Fixed a bug that `Array` argument is too wild.
    [GitHub#54][Reported by Skye Shaw]

### Thanks

  * Nikolay Shebanov

  * Yutaka HARA

  * Skye Shaw

  * soylent

  * Arthur Le Maitre

## 1.1.2 (August 17, 2013)

* Add tests, appraisals, etc. back to the published gem ([#32][i32]).
  This is necessary because Debian wraps rr in a package, and they depend on the
  tests to be present in order to run them prior to packaging.
* Add back RR::Adapters::RSpec2 which was removed accidentally ([#34][i34]).
  This fixes failures when running tests against sham_rack (which is no longer
  using RR, but, oh well).
* Remove deprecation warning about
  RSpec.configuration.backtrace_clean_patterns under RSpec 2.14 ([#37][i37]).
  NOTE: This warning will continue to appear if you are configuring RSpec using
  `mock_with :rr`. This is because the RR adapter bundled with RSpec still
  refers to `backtrace_clean_patterns` instead of
  `backtrace_exclusion_patterns`. You can either wait until the next release of
  rspec-core, or remove `mock_with :rr` (which is recommended at this point as
  we consider RSpec's adapter to be slightly out of date, and RR provides its
  own adapter for RSpec).
* RR now officially supports Rails 4.0.0. (It worked before, but now we're
  explicitly testing against it instead of 4.0.0.rc1.)
* Fix Test::Unit 1 and 2 adapters to avoid a possible "undefined
  Test::Unit::TestCase" error.
* Prevent adapters from being double-loaded.
* Including RR::Adapters::TestUnit, RR::Adapters::MiniTest, or
  RR::Adapters::RSpec2 now just re-runs the autohook mechanism instead of
  building a fake adapter, as it was possible to include both a real and fake
  adapter in the same space and they could conflict with each other.

## 1.1.1 (June 17, 2013)

* Fix incompatibility issues with Rails 4 ([#26][i26]) and Cucumber
  ([#29][i29]).
* Add missing adapter for Test::Unit 2.0.0 (version which is built into Ruby
  1.9/2.0). The tests for Jekyll were failing because of this ([#27][i27]).
* If an error occurs while checking to see whether an adapter applies or when
  loading the adapter itself, it is now swallowed so that the user can move on.

## 1.1.0 (May 20, 2013)

NOTE: RR development moved from [btakita/rr][btakita-rr] to [rr/rr][rr-rr].
Issues are re-numbered beginning from 1 from this point on.

* Fix a line in RR::Injections::DoubleInjection to use top-level RR constant
  ([#3][i3]) [[@Thibaut][Thibaut]]
* Fix all wildcard matches so they work within hashes and arrays. This means
  that `stub([hash_containing(:foo => 'bar')])` will match
  `stub([{:foo => 'bar', :baz => 'qux'}])`. ([#4][i4])
* RR now auto-hooks into whichever test framework you have loaded; there is no
  longer a need to `include RR::Adapters::Whatever` into your test framework. If
  you don't like the autohook and prefer the old way, simply use
  `require 'rr/without_autohook'` instead of `require 'rr'`. (There are now
  nine adapters; see [lib/rr/autohook.rb][autohook] for the full list.)
* Fix Test::Unit adapters to ensure that any additional teardown is completely
  run in the event that RR's verify step produces an error. This was causing
  weirdness when using Test::Unit alongside Rails. ([#2][i2])
* Add an explicit Test::Unit / ActiveSupport adapter. As ActiveSupport::TestCase
  introduces its own setup/teardown hooks, use these when autohooking in RR.
  ([#2][i2])
* Add support for Minitest 5
* Upon release, the tests are now packaged up and uploaded to S3. This is for
  Linux distros like Fedora who wrap gems in RPM packages. You can always find
  the latest tests at <http://s3.amazonaws.com/rubygem-rr/tests/vX.Y.Z.tar.gz>,
  where X.Y.Z represents a version. I have retroactively packaged the tests for
  1.0.4 and 1.0.5.

## 1.0.5 (March 28, 2013)

* Compatibility with RSpec-2. There are now two adapters for RSpec, one that
  works with RSpec-1 and a new one that works with RSpec-2. Currently, saying
  `RSpec.configure {|c| c.mock_with(:rr) }` still uses RSpec-1; to use the new
  one, you say `RSpec.configure {|c| c.mock_framework = RR::Adapters::RSpec2 }`.
  ([#66][xi66], [#68][xi68], [#80][xi80]) [[@njay][njay], [@james2m][james2m]]
* Fix MethodMissingInjection so that `[stub].flatten` works without throwing a
  NoMethodError (`undefined method `to_ary'`) error under Ruby 1.9 ([#44][xi44])
* Raise a MiniTest::Assertion error in the MiniTest adapter so that mock
  failures appear in the output as failures rather than uncaught exceptions
  ([#69][xi69]) [[@jayferd][jayferd]]
* Completely remove leftover #new_instance_of method, and also remove
  mention of #new_instance_of from the README
* Fix tests so they all work and pass again

## 1.0.4 (June 11, 2011)

* Fixed bug using workaround with leftover MethodMissingInjections

## 1.0.3 (June 11, 2011)

* Eliminate usage of ObjectSpace._id2ref ([#63][xi63]) [[@evanphx][evanphx]]
* Added minitest adapter ([#62][xi62]) [[@cespare][cespare]]
* Added instructions on installing the gem ([#57][xi57])
  [[@gavingmiller][gavingmiller]]
* delete missing scratch.rb file from gemspec ([#60][xi60])
  [[@bonkydog][bonkydog]]

## 1.0.2 (November 1, 2010)

* Fixed Two calls recorded to a mock expecting only one call when called via
  another mock's yield block ([#42][xi42]) [[@libc][libc]]

## 1.0.1 (October 30, 2010)

* Removed new_instance_of for Ruby 1.9.2 compatibility. instance_of is now an
  alias for any_instance_of.
* Compatible with Ruby 1.9.2

## 1.0.0 (August 23, 2010)

* Added any_instance_of (aliased by all_instances_of), which binds methods
  directly to the class (instead of the eigenclass).
* Subclasses of a injected class do not have their methods overridden.
* any_instance_of and new_instance_of now have a block syntax

## 0.10.11 (March 22, 2010)

* Added RR.blank_slate_whitelist
* Fixed class_eval method redefinition warning in jruby

## 0.10.10 (February 25, 2010)

* Suite passes for Ruby 1.9.1

## 0.10.9 (February 17, 2010)

* Fixed 1.8.6 bug for real

## 0.10.8 (February 17, 2010)

* Fixed 1.8.6 bug

## 0.10.7 (February 15, 2010)

* Fixed issue with DoubleInjections binding to objects overriding the method
  method.

## 0.10.6 (February 15, 2010)

* Added MIT license
* Fixed Bug - dont_allow doesn't work when it follows stub ([#20][xi20])
* Fixed exception with DoubleInjections on proxy objects ([#24][xi24])
* Fixed Bug - Can't stub attribute methods on a BelongsToAssociation
  ([#24][xi24])

## 0.10.5 (December 20, 2009)

* Fixed stack overflow caused by double include in Test::Unit adapter
  ([#16][xi16])
* Fixed warnings [[@brynary][brynary]]

## 0.10.4 (September 26, 2009)

* Handle lazily defined methods (where respond_to? returns true yet the method
  is not yet defined and the first call to method_missing defines the method).
  This pattern is used in ActiveRecord and ActionMailer.
* Fixed warning about aliasing #instance_exec in jruby.
  ([#9][xi9]) [[@nathansobo][nathansobo]]

## 0.10.2 (August 30, 2009)

* RR properly proxies subjects with private methods ([#7][xi7])

## 0.10.1 (???)

* Fixed issue with DoubleInjection not invoking methods that are lazily created
  ([#4][xi4])
* Fixed issue with mock.proxy and returns ([#2][xi2])

## 0.10.0 (June 1, 2009)

* Method is no longer invoked if respond_to? returns false. This was in place to
  support ActiveRecord association proxies, and is no longer needed.

## 0.9.0 (April 25, 2009)

* instance_of Doubles now apply to methods invoked in the subject's #initialize
  method.

## 0.8.1 (March 29, 2009)

* Fixed exception where the Subject uses method delegation via method_missing
  (e.g. certain ActiveRecord AssociationProxy methods)

##  0.8.0 (March 29, 2009)

* Fixed compatibility issues with Ruby 1.9
* Aliased any_number_of_times with any_times
* Better error messages for have_received and assert_received matchers
  [[@jferris][jferris]]
* Better documentation on RR wilcard matchers [[@phildarnowsky][phildarnowsky]]

## 0.7.1 (January 16, 2009)

* Performance improvements

## 0.7.0 (December 14, 2008)

* Added spies [[@jferris][jferris], [@niessner][niessner],
  [@mmangino][mmangino]]
* Added strongly typed reimplementation doubles [[@niessner][niessner]]

## 0.6.2 (???)

* Fixed DoubleDefinition chaining edge cases

## 0.6.1 (???)

* DoubleDefinitionCreatorProxy definition eval block is instance_evaled when the
  arity is not 1. When the arity is 1, the block is yielded with the
  DoubleDefinitionCreatorProxy passed in.

## 0.6.0 (October 13, 2008)

* Friendlier DoubleNotFound error message
* Implemented Double strategy creation methods (#mock, #stub, #proxy,
  #instance_of, and ! equivalents) on DoubleDefinition
* Implemented hash_including matcher [Matthew O'Connor]
* Implemented satisfy matcher [Matthew O'Connor]
* Implemented DoubleDefinitionCreator#mock!, #stub!, and #dont_allow!
* Modified api to method chain Doubles
* Fix conflict with Mocha overriding Object#verify

## 0.5.0 (???)

* Method chaining Doubles [[@nkallen][nkallen]]
* Chained ordered expectations [[@nkallen][nkallen]]
* Space#verify_doubles can take one or more objects with DoubleInjections to be
  verified

## 0.4.10 (July 6, 2008)

* DoubleDefinitionCreatorProxy does not undef #object_id
* Fixed rdoc pointer to README

## 0.4.9 (June 18, 2008)

* Proxying from RR module to RR::Space.instance

## 0.4.8 (January 23, 2008)

* Fixed issue with Hash arguments

## 0.4.7 (January 23, 2008)

* Improved error message

## 0.4.6 (January 23, 2008)

* Added Double#verbose and Double#verbose?

## 0.4.5 (January 15, 2008)

* Fixed doubles for == and #eql? methods

## 0.4.4 (January 15, 2008)

* Doc improvements
* Methods that are not alphabetic, such as ==, can be doubles

## 0.4.3 (January 7, 2008)

* Doc improvements
* Cleanup
* Finished renaming scenario to double

## 0.4.2 (December 31, 2007)

* Renamed DoubleInsertion to DoubleInjection to be consistent with Mocha
  terminology

## 0.4.1 (December 31, 2007)

* Fixed backward compatability issues with rspec
* Renamed Space#verify_double_insertions to #verify_doubles

## 0.4.0 (December 30, 2007)

* Documentation improvements
* Renamed Double to DoubleInsertion
* Renamed Scenario to Double

## 0.3.11 (September 6, 2007)

* Fixed [#13724] Mock Proxy on Active Record Association proxies causes error

## 0.3.10 (August 18, 2007)

* Fixed [#13139] Blocks added to proxy sets the return_value and not the
  after_call callback

## 0.3.9 (August 14, 2007)

* Alias probe to proxy

## 0.3.8 (August 12, 2007)

* Implemented [#13009] Better error mesage from TimesCalledMatcher

## 0.3.7 (August 9, 2007)

* Fixed [#12928] Reset doubles fails on Rails association proxies

## 0.3.6 (August 1, 2007)

* Fixed [#12765] Issues with ObjectSpace._id2ref

## 0.3.5 (July 29, 2007)

* trim_backtrace is only set for Test::Unit

## 0.3.4 (July 22, 2007)

* Implemented instance_of

## 0.3.3 (July 22, 2007)

* Fixed [#12495] Error Probing method_missing interaction

## 0.3.2 (July 22, 2007)

* Fixed [#12486] ScenarioMethodProxy when Kernel passed into instance methods

## 0.3.1 (July 22, 2007)

* Automatically require Test::Unit and Rspec adapters

## 0.3.0 (July 22, 2007)

* ScenarioCreator strategy method chaining
* Removed mock_probe
* Removed stub_probe

## 0.2.5 (July 21, 2007)

* mock takes method_name argument
* stub takes method_name argument
* mock_probe takes method_name argument
* stub_probe takes method_name argument
* probe takes method_name argument
* dont_allow takes method_name argument
* do_not_allow takes method_name argument

## 0.2.4 (July 19, 2007)

* Space#doubles key is now the object id
* Fixed [#12402] Stubbing return value of probes fails after calling the stubbed
  method two times

## 0.2.3 (July 18, 2007)

* Added RRMethods#rr_verify and RRMethods#rr_reset

## 0.2.2 (July 17, 2007)

* Fixed "singleton method bound for a different object"
* Doing Method aliasing again to store original method

## 0.2.1 (July 17, 2007)

* Added mock_probe
* Added stub_probe
* Probe returns the return value of the passed in block, instead of ignoring its
  return value
* Scenario#after_call returns the return value of the passed in block
* Not using method aliasing to store original method
* Renamed DoubleMethods to RRMethods
* Added RRMethods#mock_probe

## 0.1.15 (July 17, 2007)

* Fixed [#12333] Rebinding original_methods causes blocks not to work

## 0.1.14 (July 16, 2007)

* Introduced concept of Terminal and NonTerminal TimesCalledMatchers
* Doubles that can be called many times can be replaced
* Terminal Scenarios are called before NonTerminal Scenarios
* Error message tweaking
* Raise error when making a Scenarios with NonTerminal TimesMatcher Ordered

## 0.1.13 (July 14, 2007)

* Fixed [#12290] Scenario#returns with false causes a return value of nil

## 0.1.12 (July 14, 2007)

* Fixed bug where Creators methods are not removed when methods are defined on
  Object
* Fixed [#12289] Creators methods are not removed in Rails environment

## 0.1.11 (July 14, 2007)

* Fixed [#12287] AtLeastMatcher does not cause Scenario to be called

## 0.1.10 (July 14, 2007)

* Fixed [#12286] AnyArgumentExpectation#expected_arguments not implemented

## 0.1.9 (July 14, 2007)

* Added DoubleMethods#any_times
* Added Scenario#any_number_of_times

## 0.1.8 (July 14, 2007)

* TimesCalledError Message Formatted to be on multiple lines
* ScenarioNotFoundError Message includes all Scenarios for the Double
* ScenarioOrderError shows list of remaining ordered scenarios

## 0.1.7 (July 14, 2007)

* Fixed [#12194] Double#reset_doubles are not clearing Ordered Scenarios bug
* Added Space#reset
* Space#reset_doubles and Space#reset_ordered_scenarios is now protected
* Added Scenario#at_least
* Added Scenario#at_most

## 0.1.6 (July 10, 2007)

* [#12120] probe allows a the return value to be intercepted

## 0.1.5 (July 9, 2007)

* TimesCalledExpectation says how many times were called and how many times
  called were expected on error

## 0.1.4 (July 9, 2007)

* TimesCalledError prints the backtrace to where the Scenario was defined when
  being verified
* Error message includes method name when Scenario is not found

## 0.1.3 (July 9, 2007)

* Fixed issue where Double#placeholder_name issues when Double method name has a
  ! or ?

## 0.1.2 (July 8, 2007)

* Scenario#returns also accepts an argument
* Implemented Scenario#yields

## 0.1.1 (July 8, 2007)

* Trim the backtrace for Rspec and Test::Unit
* Rspec and Test::Unit integration fixes

## 0.1.0 (July 7, 2007)

* Initial Release

[btakita-rr]: http://github.com/btakita/rr
[rr-rr]: http://github.com/rr/rr
[i2]: http://github.com/rr/rr/issues/2
[i3]: http://github.com/rr/rr/issues/3
[Thibaut]: http://github.com/Thibaut
[i4]: http://github.com/rr/rr/issues/4
[xi66]: http://github.com/btakita/rr/issues/66
[xi68]: http://github.com/btakita/rr/issues/68
[xi80]: http://github.com/btakita/rr/issues/80
[njay]: http://github.com/njay
[james2m]: http://github.com/james2m
[xi44]: http://github.com/btakita/rr/issues/44
[xi69]: http://github.com/btakita/rr/issues/69
[jayferd]: http://github.com/jayferd
[autohook]: https://github.com/rr/rr/blob/master/lib/rr/autohook.rb
[evanphx]: http://github.com/evanphx
[xi63]: http://github.com/btakita/rr/issues/63
[xi63]: http://github.com/btakita/rr/issues/62
[cespare]: http://github.com/cespare
[gavingmiller]: http://github.com/gavingmiller
[bonkydog]: http://github.com/bonkydog
[xi42]: http://github.com/btakita/rr/issues/42
[libc]: http://github.com/libc
[brynary]: http://github.com/brynary
[xi9]: http://github.com/btakita/rr/issues/9
[nathansobo]: http://github.com/nathansobo
[xi7]: http://github.com/btakita/rr/issues/7
[xi4]: http://github.com/btakita/rr/issues/4
[xi2]: http://github.com/btakita/rr/issues/2
[nkallen]: http://github.com/nkallen
[jferris]: http://github.com/jferris
[phildarnowsky]: http://github.com/phildarnowsky
[niessner]: http://github.com/niessner
[mmangino]: http://github.com/mmangino
[xi20]: http://github.com/btakita/rr/issues/20
[xi24]: http://github.com/btakita/rr/issues/24
[xi16]: http://github.com/btakita/rr/issues/16
[xi62]: http://github.com/btakita/rr/issues/62
[xi57]: http://github.com/btakita/rr/issues/57
[xi60]: http://github.com/btakita/rr/issues/60
[i26]: http://github.com/rr/rr/issues/26
[i29]: http://github.com/rr/rr/issues/29
[i27]: http://github.com/rr/rr/issues/27
[i34]: http://github.com/rr/rr/issues/34
[i32]: http://github.com/rr/rr/issues/32
[i37]: http://github.com/rr/rr/issues/37

