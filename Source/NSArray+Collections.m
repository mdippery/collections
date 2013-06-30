/*
 * Copyright (C) 2011 Michael Dippery <michael@monkey-robot.com>
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
#import "Common.h"
#import "CommonHelpers.h"
#import "MDPair.h"


@implementation NSArray (SmalltalkCollections)

- (NSArray *)do:(void (^)(id obj))block
{
    if ([self respondsToSelector:@selector(enumerateObjectsUsingBlock:)]) {
        [self enumerateObjectsUsingBlock:^ (id obj, NSUInteger idx, BOOL *stop) { block(obj); }];
    } else {
        do_foreach(self, block);
    }
    return self;
}

- (NSArray *)collect:(id (^)(id obj))block
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:[self count]];
    return collect_foreach(self, a, block);
}

- (id)detect:(BOOL (^)(id obj))block
{
    return default_detect(self, block);
}

- (id)detect:(BOOL (^)(id obj))block ifNone:(id (^)(void))none
{
    return detect_foreach(self, block, none);
}

- (id)inject:(id)initial into:(id (^)(id memo, id obj))block
{
    return inject_foreach(self, initial, block);
}

- (NSArray *)reject:(BOOL (^)(id obj))block
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:[self count]];
    return reject_foreach(self, a, block);
}

- (NSArray *)select:(BOOL (^)(id obj))block
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:[self count]];
    return select_foreach(self, a, block);
}

@end

@implementation NSArray (RubyEnumerable)

- (BOOL)all:(BOOL (^)(id obj))block
{
    return all_foreach(self, block);
}

- (BOOL)any:(BOOL (^)(id obj))block
{
    return any_foreach(self, block);
}

- (BOOL)none:(BOOL (^)(id obj))block
{
    return none_foreach(self, block);
}

- (BOOL)one:(BOOL (^)(id obj))block
{
    return one_foreach(self, block);
}

- (NSArray *)drop:(NSUInteger)n
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:[self count]-n];
    for (NSUInteger i = n; i < [self count]; i++) {
        [a addObject:[self objectAtIndex:i]];
    }
    return [a freeze];
}

- (NSArray *)dropWhile:(BOOL (^)(id obj))block
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:[self count]/2];
    return drop_foreach(self, a, block);
}

- (id)max:(NSComparator)block
{
    return find_max(self, block);
}

- (id)min:(NSComparator)block
{
    return find_min(self, block);
}

- (MDPair *)partition:(BOOL (^)(id obj))block
{
    NSMutableArray *trueVals = [NSMutableArray arrayWithCapacity:[self count]/2];
    NSMutableArray *falseVals = [NSMutableArray arrayWithCapacity:[self count]/2];
    return partition_foreach(self, trueVals, falseVals, block);
}

- (NSArray *)take:(NSUInteger)n
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:n];
    for (NSUInteger i = 0U; i < n; i++) {
        [a addObject:[self objectAtIndex:i]];
    }
    return [a freeze];
}

- (NSArray *)takeWhile:(BOOL (^)(id obj))block
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:[self count]];
    return take_foreach(self, a, block);
}

@end
