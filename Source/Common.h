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

#import <Foundation/Foundation.h>

@class MDPair;

#define find_max(collection, cmp)   do_comparison(collection, cmp, NSOrderedDescending)
#define find_min(collection, cmp)   do_comparison(collection, cmp, NSOrderedAscending)

#define default_detect(self, block) [self detect:block ifNone:^ id (void) { return nil; }];

extern id do_comparison(id collection, NSComparator cmp, NSComparisonResult val);

extern void do_foreach(id collection, void (^block)(id));
extern id collect_foreach(id collection, id acc, id (^block)(id));
extern id detect_foreach(id collection, BOOL (^detect)(id), id (^none)(void));
extern id inject_foreach(id collection, id initial, id (^into)(id, id));
extern id select_foreach(id collection, id acc, BOOL (^block)(id));
extern id reject_foreach(id collection, id acc, BOOL (^block)(id));

extern BOOL all_foreach(id collection, BOOL (^block)(id));
extern BOOL any_foreach(id collection, BOOL (^block)(id));
extern BOOL none_foreach(id collection, BOOL (^block)(id));
extern BOOL one_foreach(id collection, BOOL (^block)(id));
extern id drop_foreach(id collection, id acc, BOOL (^drop)(id));
extern MDPair *partition_foreach(id collection, id trueAcc, id falseAcc, BOOL (^block)(id));
extern id take_foreach(id collection, id acc, BOOL (^take)(id));
