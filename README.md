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
OS X only; I'd like to add support for building as a static library for iOS,
but I don't have an iOS developer's account and don't really write iPhone
software. However, the code isn't terribly complicated, so adding iOS
support should be trivial.

## Can I use it now?

Meh. Most of the planned functionality is implemented for `NSArray` and
`NSSet`, but it hasn't been extensively tested (to be honest, the unit tests
are kind of pathetic), nor has the code been written as "tightly" or
efficiently as it could be. This is an early in-development version at the
moment, so use at your own risk.

## Can you make it work on the iPhone?

I'm working on iOS support. I'm a Mac developer, not an iPhone developer,
so I don't have one of those newfangled gotta-pay-a-fee iPhone developer's
accounts yet. That said, **libCollections** only uses Foundation classes, so
compiling it as an iOS-compatible static library shouldn't be terribly
difficult.

## Who created this?

**libCollections** is written by Michael Dippery. I had been meaning to create
such a library for a while (I like the `collect:` and `inject:into:` methods
from Smalltalk and Ruby, and miss them in Objective-C), but I was motivated
to finally sit down and write the code by a [post][SO] on Stack Overflow.

[Smalltalk]: http://www.ifi.uzh.ch/richter/Classes/oose2/01_Collections/03_smalltalk/03_smalltalk.html#2%20Collection%20Protocol
[Ruby]: http://ruby-doc.org/core/classes/Enumerable.html
[SO]: http://stackoverflow.com/q/4650820/28804
