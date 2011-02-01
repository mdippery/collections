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

#import "NSDictionaryCollections.h"
#import "Common.h"


@implementation NSDictionary (SmalltalkCollections)

- (NSDictionary *)do:(void (^)(id obj))block
{
    do_foreach(self, block);
    return self;
}

- (NSDictionary *)collect:(id (^)(id obj))block
{
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:[self count]];
    return collect_foreach(self, d, block);
}

- (id)inject:(id)initial into:(id (^)(id memo, id obj))block
{
    return inject_foreach(self, initial, block);
}

- (NSDictionary *)reject:(BOOL (^)(id obj))block
{
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:[self count]];
    return reject_foreach(self, d, block);
}

- (NSDictionary *)select:(BOOL (^)(id obj))block
{
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:[self count]];
    return select_foreach(self, d, block);
}

@end

@implementation NSDictionary (RubyEnumerable)

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
    NSMutableDictionary *t = [NSMutableDictionary dictionaryWithCapacity:[self count] / 2];
    NSMutableDictionary *f = [NSMutableDictionary dictionaryWithCapacity:[self count] / 2];
    return partition_foreach(self, t, f, block);
}

@end
