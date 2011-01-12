/*
 * Copyright (C) 2011 Michael Dippery <mdippery@gmail.com>
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

#import "NSArray+Collections.h"


@implementation NSArray (SmalltalkCollections)

- (NSArray *)collect:(id (^)(id obj))block
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:[self count]];
    for (id item in self) {
        [a addObject:block(item)];
    }
    return [[a copy] autorelease];
}

- (id)detect:(BOOL (^)(id obj))block
{
    return [self detect:block ifNone:^ id { return nil; }];
}

- (id)detect:(BOOL (^)(id obj))block ifNone:(id (^)(void))none
{
    for (id item in self) {
        if (block(item)) return item;
    }
    return none();
}

- (id)inject:(id)initial into:(id (^)(id memo, id obj))block
{
    for (id item in self) {
        initial = block(initial, item);
    }
    return initial;
}

- (NSArray *)reject:(BOOL (^)(id obj))block
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:[self count]];
    for (id item in self) {
        if (!block(item)) {
            [a addObject:item];
        }
    }
    return [[a copy] autorelease];
}

- (NSArray *)select:(BOOL (^)(id obj))block
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:[self count]];
    for (id item in self) {
        if (block(item)) {
            [a addObject:item];
        }
    }
    return [[a copy] autorelease];
}

@end

@implementation NSArray (RubyEnumerable)

- (id)_valueOf:(NSComparisonResult (^)(id left, id right))block comparingTo:(NSComparisonResult)compare
{
    if ([self count] == 0) return nil;

    id cur = [self objectAtIndex:0];
    for (NSUInteger i = 1U; i < [self count]; i++) {
        id item = [self objectAtIndex:i];
        NSComparisonResult result = block(cur, item);
        if (result == compare) {
            cur = item;
        }
    }
    return cur;
}

- (BOOL)all:(BOOL (^)(id obj))block
{
    for (id item in self) {
        if (!block(item)) return NO;
    }
    return YES;
}

- (BOOL)any:(BOOL (^)(id obj))block
{
    for (id item in self) {
        if (block(item)) return YES;
    }
    return NO;
}

- (BOOL)none:(BOOL (^)(id obj))block
{
    for (id item in self) {
        if (block(item)) return NO;
    }
    return YES;
}

- (BOOL)one:(BOOL (^)(id obj))block
{
    BOOL sawOne = NO;
    for (id item in self) {
        if (block(item)) {
            if (sawOne) {
                return NO;
            } else {
                sawOne = YES;
            }
        }
    }
    return sawOne;
}

- (NSArray *)drop:(NSUInteger)n
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:[self count]-n];
    for (NSUInteger i = n; i < [self count]; i++) {
        [a addObject:[self objectAtIndex:i]];
    }
    return [[a copy] autorelease];
}

- (NSArray *)dropWhile:(BOOL (^)(id obj))block
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:[self count]/2];
    NSUInteger cur = 0U;

    for (cur = 0U; cur < [self count]; cur++) {
        id item = [self objectAtIndex:cur];
        if (!block(item)) break;
    }

    for (; cur < [self count]; cur++) {
        [a addObject:[self objectAtIndex:cur]];
    }

    return [[a copy] autorelease];
}

- (id)max:(NSComparisonResult (^)(id left, id right))block
{
    return [self _valueOf:block comparingTo:NSOrderedAscending];
}

- (id)min:(NSComparisonResult (^)(id left, id right))block
{
    return [self _valueOf:block comparingTo:NSOrderedDescending];
}

- (NSArray *)partition:(BOOL (^)(id obj))block
{
    NSMutableArray *trueVals = [NSMutableArray arrayWithCapacity:[self count]/2];
    NSMutableArray *falseVals = [NSMutableArray arrayWithCapacity:[self count]/2];
    for (id item in self) {
        if (block(item)) {
            [trueVals addObject:item];
        } else {
            [falseVals addObject:item];
        }
    }
    return [NSArray arrayWithObjects:[[trueVals copy] autorelease], [[falseVals copy] autorelease], nil];
}

- (NSArray *)take:(NSUInteger)n
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:n];
    for (NSUInteger i = 0U; i < n; i++) {
        [a addObject:[self objectAtIndex:i]];
    }
    return [[a copy] autorelease];
}

- (NSArray *)takeWhile:(BOOL (^)(id obj))block
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:[self count]];
    for (id item in self) {
        if (!block(item)) {
            return [[a copy] autorelease];
        } else {
            [a addObject:item];
        }
    }
    return [[a copy] autorelease];
}

@end
