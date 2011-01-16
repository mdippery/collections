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

#import "Common.h"

#define IMMUTABLE_COPY(o)   [[o copy] autorelease]

void do_foreach(id collection, void (^block)(id))
{
    for (id item in collection) {
        block(item);
    }
}

id collect_foreach(id collection, id acc, id (^block)(id))
{
    for (id item in collection) {
        [acc addObject:block(item)];
    }
    return IMMUTABLE_COPY(acc);
}

id detect_foreach(id collection, BOOL (^detect)(id), id (^none)(void))
{
    for (id item in collection) {
        if (detect(item)) return item;
    }
    return none();
}

id inject_foreach(id collection, id initial, id (^into)(id, id))
{
    for (id item in collection) {
        initial = into(initial, item);
    }
    return initial;
}

id select_foreach(id collection, id acc, BOOL (^block)(id))
{
    for (id item in collection) {
        if (block(item)) {
            [acc addObject:item];
        }
    }
    return IMMUTABLE_COPY(acc);
}

id reject_foreach(id collection, id acc, BOOL (^block)(id))
{
    for (id item in collection) {
        if (!block(item)) {
            [acc addObject:item];
        }
    }
    return [[acc copy] autorelease];
}

id do_comparison(id collection, NSComparator cmp, NSComparisonResult val)
{
    id result = nil;
    BOOL isFirst = YES;
    for (id item in collection) {
        if (isFirst) {
            result = item;
            isFirst = NO;
            continue;
        }
        result = cmp(item, result) == val ? item : result;
    }
    return result;
}

BOOL all_foreach(id collection, BOOL (^block)(id))
{
    for (id item in collection) {
        if (!block(item)) return NO;
    }
    return YES;
}

BOOL any_foreach(id collection, BOOL (^block)(id))
{
    for (id item in collection) {
        if (block(item)) return YES;
    }
    return NO;
}

BOOL none_foreach(id collection, BOOL (^block)(id))
{
    for (id item in collection) {
        if (block(item)) return NO;
    }
    return YES;
}

BOOL one_foreach(id collection, BOOL (^block)(id))
{
    BOOL sawOne = NO;
    for (id item in collection) {
        if (block(item)) {
            if (sawOne) return NO;
            sawOne = YES;
        }
    }
    return sawOne;
}

id drop_foreach(id collection, id acc, BOOL (^drop)(id obj))
{
    BOOL dropFailed = NO;
    for (id item in collection) {
        if (dropFailed) {
            [acc addObject:item];
        } else {
            if (!drop(item)) {
                dropFailed = YES;
                [acc addObject:item];
            }
        }
    }
    return IMMUTABLE_COPY(acc);
}

NSArray *partition_foreach(id collection, id trueAcc, id falseAcc, BOOL (^block)(id))
{
    for (id item in collection) {
        id acc = block(item) ? trueAcc : falseAcc;
        [acc addObject:item];
    }
    
    id t = [[trueAcc copy] autorelease];
    id f = [[falseAcc copy] autorelease];
    return [NSArray arrayWithObjects:t, f, nil];
}

id take_foreach(id collection, id acc, BOOL (^take)(id))
{
    for (id item in collection) {
        if (!take(item)) return IMMUTABLE_COPY(acc);
        [acc addObject:item];
    }
    return IMMUTABLE_COPY(acc);
}
