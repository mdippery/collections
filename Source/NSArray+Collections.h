/*
 * Copyright (C) 2011-2013 Michael Dippery <michael@monkey-robot.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import "Collections.h"

@class MDPair;


@interface NSArray (SmalltalkCollections)
- (NSArray *)do:(MDElementMutator)block;
- (NSArray *)collect:(MDElementTransformer)block;
- (id)detect:(MDElementFilter)block;
- (id)detect:(MDElementFilter)block ifNone:(MDElementDefault)none;
- (id)inject:(id)initial into:(MDElementInjector)block;
- (NSArray *)reject:(MDElementFilter)block;
- (NSArray *)select:(MDElementFilter)block;
@end

@interface NSArray (RubyEnumerable)
- (BOOL)all:(MDElementFilter)block;
- (BOOL)any:(MDElementFilter)block;
- (BOOL)none:(MDElementFilter)block;
- (BOOL)one:(MDElementFilter)block;
- (NSArray *)drop:(NSUInteger)n;
- (NSArray *)dropWhile:(MDElementFilter)block;
- (id)max:(NSComparator)block;
- (id)min:(NSComparator)block;
- (MDPair *)partition:(MDElementFilter)block;
- (NSArray *)take:(NSUInteger)n;
- (NSArray *)takeWhile:(MDElementFilter)block;
@end
