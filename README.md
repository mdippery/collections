# libCollections

**libCollections** is an Objective-C library that brings methods from
Smalltalk's [collection protocol][Smalltalk] and Ruby's
[`Enumerable`][Ruby] mixin to Objective-C projects. **libCollections** adds
these methods as categories to the Foundation framework's collections classes.
Currently only `NSArray` is modified, and not all of Ruby's `Enumerable`
methods are implemented. (Some of them aren't really relevant or useful and
probably won't be.)

## What does it run on?

**libCollections** uses C blocks extensively. Right now it's only designed to
compile on Mac OS X 10.6; it can probably compile on 10.5 as well, but I
haven't set that up yet. Currently it compiles as a dynamic library on OS X
only; I'd like to add support for building as a static library for iOS, but
I don't have an iOS developer's account and don't really write iPhone
software. However, the code isn't terribly complicated, so adding iOS
support should be trivial.

## Who created this?

**libCollections** is written by Michael Dippery. I had been meaning to create
such a library for a while (I like the `collect:` and `inject:into:` methods
from Smalltalk and Ruby, and miss them in Objective-C), but I was motivated
to finally sit down and write the code by a [post][SO] on Stack Overflow.

[Smalltalk]: http://www.ifi.uzh.ch/richter/Classes/oose2/01_Collections/03_smalltalk/03_smalltalk.html#2%20Collection%20Protocol
[Ruby]: http://ruby-doc.org/core/classes/Enumerable.html
[SO]: http://stackoverflow.com/q/4650820/28804
