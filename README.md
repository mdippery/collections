# libCollections

**libCollections** is an Objective-C library that brings methods from
Smalltalk's [collection protocol][Smalltalk] and Ruby's
[`Enumerable`][Ruby] mixin to Objective-C projects. **libCollections** adds
these methods as categories to the Foundation framework's collections classes.
(Not all of Ruby's `Enumerable` methods are implemented, but some of them
aren't really relevant or useful and probably won't be.)

## What does it run on?

**libCollections** uses C blocks extensively. I've only tested it on 10.6, but
it should work on 10.5 as well. Currently it compiles as a dynamic library on
OS X, and as a static library for iOS.

## Can I use it now?

Maybe. The planned functionality is implemented for `NSArray`, `NSSet`, and
`NSDictionary`, but it hasn't been extensively tested (to be honest, the unit
tests are kind of pathetic), nor has the code been written as "tightly" or
efficiently as it could be. It hasn't been tested in an iOS app at all. This
is an early in-development version at the moment, so use at your own risk.

## Who created this?

**libCollections** is written by Michael Dippery. I had been meaning to create
such a library for a while (I like the `collect:` and `inject:into:` methods
from Smalltalk and Ruby, and miss them in Objective-C), but I was motivated
to finally sit down and write the code by a [post][SO] on Stack Overflow.

[Smalltalk]: http://www.ifi.uzh.ch/richter/Classes/oose2/01_Collections/03_smalltalk/03_smalltalk.html#2%20Collection%20Protocol
[Ruby]:      http://ruby-doc.org/core/classes/Enumerable.html
[SO]:        http://stackoverflow.com/q/4650820/28804
