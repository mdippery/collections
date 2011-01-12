#import <Foundation/Foundation.h>


@interface NSArray (Collections)

// Smalltalk collections methods
- (NSArray *)collect:(id (^)(id obj))block;
- (id)detect:(BOOL (^)(id obj))block;
- (id)detect:(BOOL (^)(id obj))block ifNone:(id (^)())none;
- (id)inject:(id)initial into:(id (^)(id memo, id obj))block;
- (NSArray *)reject:(BOOL (^)(id obj))block;
- (NSArray *)select:(BOOL (^)(id obj))block;

// Additional Ruby collections methods
- (BOOL)all:(BOOL (^)(id obj))block;
- (BOOL)any:(BOOL (^)(id obj))block;
- (BOOL)none:(BOOL (^)(id obj))block;
- (BOOL)one:(BOOL (^)(id obj))block;
- (NSArray *)drop:(NSUInteger)n;
- (NSArray *)dropWhile:(BOOL (^)(id obj))block;
- (NSArray *)first:(NSUInteger)n;
- (id)max:(NSComparisonResult (^)(id left, id right))block;
- (id)min:(NSComparisonResult (^)(id left, id right))block;
- (NSArray *)partition:(BOOL (^)(id obj))block;
- (NSArray *)take:(NSUInteger)n;
- (NSArray *)takeWhile:(BOOL (^)(id obj))block;

@end
