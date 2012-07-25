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


@interface NSArray (SmalltalkCollections)
- (NSArray *)do:(void (^)(id obj))block;
- (NSArray *)collect:(id (^)(id obj))block;
- (id)detect:(BOOL (^)(id obj))block;
- (id)detect:(BOOL (^)(id obj))block ifNone:(id (^)(void))none;
- (id)inject:(id)initial into:(id (^)(id memo, id obj))block;
- (NSArray *)reject:(BOOL (^)(id obj))block;
- (NSArray *)select:(BOOL (^)(id obj))block;
@end

@interface NSArray (RubyEnumerable)
- (BOOL)all:(BOOL (^)(id obj))block;
- (BOOL)any:(BOOL (^)(id obj))block;
- (BOOL)none:(BOOL (^)(id obj))block;
- (BOOL)one:(BOOL (^)(id obj))block;
- (NSArray *)drop:(NSUInteger)n;
- (NSArray *)dropWhile:(BOOL (^)(id obj))block;
- (id)max:(NSComparator)block;
- (id)min:(NSComparator)block;
- (MDPair *)partition:(BOOL (^)(id obj))block;
- (NSArray *)take:(NSUInteger)n;
- (NSArray *)takeWhile:(BOOL (^)(id obj))block;
@end
