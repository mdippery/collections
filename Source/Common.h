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

#define find_max(collection, cmp)   do_comparison(collection, cmp, NSOrderedDescending)
#define find_min(collection, cmp)   do_comparison(collection, cmp, NSOrderedAscending)

#define default_detect(self, block) [self detect:block ifNone:^ id (void) { return nil; }];

extern id do_comparison(id collection, NSComparator cmp, NSComparisonResult val);

extern void do_foreach(id collection, MDElementMutator);
extern id collect_foreach(id collection, id acc, MDElementTransformer);
extern id detect_foreach(id collection, MDElementFilter, MDElementDefault);
extern id inject_foreach(id collection, id initial, MDElementInjector);
extern id select_foreach(id collection, id acc, MDElementFilter);
extern id reject_foreach(id collection, id acc, MDElementFilter);

extern BOOL all_foreach(id collection, MDElementFilter);
extern BOOL any_foreach(id collection, MDElementFilter);
extern BOOL none_foreach(id collection, MDElementFilter);
extern BOOL one_foreach(id collection, MDElementFilter);
extern id drop_foreach(id collection, id acc, MDElementFilter);
extern MDPair *partition_foreach(id collection, id trueAcc, id falseAcc, MDElementFilter);
extern id take_foreach(id collection, id acc, MDElementFilter);
