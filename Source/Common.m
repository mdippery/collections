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

#import "Common.h"
#import "MDPair.h"
#import "CommonHelpers.h"

void do_foreach(id collection, MDElementMutator block)
{
    for (id val in collection) {
        id item = [collection objectForValue:val];
        block(item);
    }
}

id collect_foreach(id collection, id acc, MDElementTransformer block)
{
    for (id val in collection) {
        id item = [collection objectForValue:val];
        [acc setObject:block(item) forValue:val];
    }
    return [acc freeze];
}

id detect_foreach(id collection, MDElementFilter detect, MDElementDefault none)
{
    for (id item in collection) {
        if (detect(item)) return item;
    }
    return none();
}

id inject_foreach(id collection, id initial, MDElementInjector into)
{
    for (id val in collection) {
        id item = [collection objectForValue:val];
        initial = into(initial, item);
    }
    return initial;
}

id select_foreach(id collection, id acc, MDElementFilter block)
{
    for (id val in collection) {
        id item = [collection objectForValue:val];
        if (block(item)) {
            [acc setObject:item forValue:val];
        }
    }
    return [acc freeze];
}

id reject_foreach(id collection, id acc, MDElementFilter block)
{
    for (id val in collection) {
        id item = [collection objectForValue:val];
        if (!block(item)) {
            [acc setObject:item forValue:val];
        }
    }
    return [acc freeze];
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

BOOL all_foreach(id collection, MDElementFilter block)
{
    for (id item in collection) {
        if (!block(item)) return NO;
    }
    return YES;
}

BOOL any_foreach(id collection, MDElementFilter block)
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

BOOL one_foreach(id collection, MDElementFilter block)
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

id drop_foreach(id collection, id acc, MDElementFilter drop)
{
    BOOL dropFailed = NO;
    for (id val in collection) {
        id item = [collection objectForValue:val];
        if (dropFailed) {
            [acc setObject:item forValue:val];
        } else {
            if (!drop(item)) {
                dropFailed = YES;
                [acc setObject:item forValue:val];
            }
        }
    }
    return [acc freeze];
}

MDPair *partition_foreach(id collection, id trueAcc, id falseAcc, MDElementFilter block)
{
    for (id val in collection) {
        id item = [collection objectForValue:val];
        id acc = block(item) ? trueAcc : falseAcc;
        [acc setObject:item forValue:val];
    }
    return [MDPair pairWithFirstObject:[trueAcc freeze] secondObject:[falseAcc freeze]];
}

id take_foreach(id collection, id acc, MDElementFilter take)
{
    for (id val in collection) {
        id item = [collection objectForValue:val];
        if (!take(item)) goto take_exit;
        [acc setObject:item forValue:val];
    }
take_exit:
    return [acc freeze];
}
