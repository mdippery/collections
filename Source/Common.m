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
#import "MDPair.h"

#define IS_DICTIONARY(c)    [c isKindOfClass:[NSDictionary class]]
#define IMMUTABLE_COPY(o)   [[o copy] autorelease]

static id get_item(id collection, id val)
{
    return IS_DICTIONARY(collection) ? [collection objectForKey:val] : val;
}

static void set_item(id acc, id item, id val)
{
    if (IS_DICTIONARY(acc)) {
        [acc setObject:item forKey:val];
    } else {
        [acc addObject:item];
    }
}

void do_foreach(id collection, void (^block)(id))
{
    for (id item in collection) {
        block(item);
    }
}

id collect_foreach(id collection, id acc, id (^block)(id))
{
    for (id val in collection) {
        id item = get_item(collection, val);
        set_item(acc, block(item), val);
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
    for (id val in collection) {
        id item = get_item(collection, val);
        if (block(item)) {
            set_item(acc, item, val);
        }
    }
    return IMMUTABLE_COPY(acc);
}

id reject_foreach(id collection, id acc, BOOL (^block)(id))
{
    for (id val in collection) {
        id item = get_item(collection, val);
        if (!block(item)) {
            set_item(acc, item, val);
        }
    }
    return IMMUTABLE_COPY(acc);
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
    for (id val in collection) {
        id item = get_item(collection, val);
        if (dropFailed) {
            set_item(acc, item, val);
        } else {
            if (!drop(item)) {
                dropFailed = YES;
                set_item(acc, item, val);
            }
        }
    }
    return IMMUTABLE_COPY(acc);
}

MDPair *partition_foreach(id collection, id trueAcc, id falseAcc, BOOL (^block)(id))
{
    for (id val in collection) {
        id item = get_item(collection, val);
        id acc = block(item) ? trueAcc : falseAcc;
        set_item(acc, item, val);
    }
    return [MDPair pairWithFirstObject:IMMUTABLE_COPY(trueAcc) secondObject:IMMUTABLE_COPY(falseAcc)];
}

id take_foreach(id collection, id acc, BOOL (^take)(id))
{
    for (id val in collection) {
        id item = get_item(collection, val);
        if (!take(item)) goto take_exit;
        set_item(acc, item, val);
    }
take_exit:
    return IMMUTABLE_COPY(acc);
}
