# Syntax between RR and other double/mock frameworks

## Terse syntax

One of the goals of RR is to make doubles more scannable. This is accomplished
by making the double declaration look as much as the actual method invocation as
possible. Here is RR compared to other mock frameworks:

~~~ ruby
# Flexmock
flexmock(User).should_receive(:find).with('42').and_return(jane)
# Mocha
User.expects(:find).with('42').returns { jane }
# rspec-mocks
User.should_receive(:find).with('42') { jane }
# RR
mock(User).find('42') { jane }
~~~

## Double injections (aka partial mocking)

RR utilizes a technique known as "double injection".

~~~ ruby
my_object = MyClass.new
mock(my_object).hello
~~~

Compare this with doing a mock in Mocha:

~~~ ruby
my_mocked_object = mock()
my_mocked_object.expects(:hello)
~~~

## Pure mock objects

If you wish to use objects for the sole purpose of being a mock, you can do so
by creating an empty object:

~~~ ruby
mock(my_mock_object = Object.new).hello
~~~

However as a shortcut you can also use #mock!:

~~~ ruby
# Create a new mock object with an empty #hello method, then retrieve that mock
# object via the #subject method
my_mock_object = mock!.hello.subject
~~~

## No #should_receive or #expects method

RR uses #method_missing to set your method expectation. This means you do not
need to use a method such as #should_receive or #expects.

~~~ ruby
# In Mocha, #expects sets the #hello method expectation:
my_object.expects(:hello)
# Using rspec-mocks, #should_receive sets the #hello method expectation:
my_object.should_receive(:hello)
# And here's how you say it using RR:
mock(my_object).hello
~~~

## #with method call is not necessary

The fact that RR uses #method_missing also makes using the #with method
unnecessary in most circumstances to set the argument expectation itself
(although you can still use it if you want):

~~~ ruby
# Mocha
my_object.expects(:hello).with('bob', 'jane')
# rspec-mocks
my_object.should_receive(:hello).with('bob', 'jane')
# RR
mock(my_object).hello('bob', 'jane')
mock(my_object).hello.with('bob', 'jane')  # same thing, just more verbose
~~~

## Using a block to set the return value

RR supports using a block to set the return value as opposed to a specific
method call (although again, you can use #returns if you like):

~~~ ruby
# Mocha
my_object.expects(:hello).with('bob', 'jane').returns('Hello Bob and Jane')
# rspec-mocks
my_object.should_receive(:hello).with('bob', 'jane') { 'Hello Bob and Jane' }
my_object.should_receive(:hello).with('bob', 'jane').and_return('Hello Bob and Jane')  # same thing, just more verbose
# RR
mock(my_object).hello('bob', 'jane') { 'Hello Bob and Jane' }
mock(my_object).hello('bob', 'jane').returns('Hello Bob and Jane')  # same thing, just more verbose
~~~
