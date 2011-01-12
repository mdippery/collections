#import "TestCollections.h"
#import "NSArray+Collections.h"


@implementation TestCollections

- (void)setUp
{
    allPositive = [[NSMutableArray alloc] initWithCapacity:10];
    allNegative = [[NSMutableArray alloc] initWithCapacity:10];
    mixed = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSInteger i = 1; i <= 10; i++) {
        NSInteger aVal = i;
        NSInteger bVal = -i;
        NSInteger cVal = i % 2 == 0 ? i : -i;
        [allPositive addObject:[NSNumber numberWithInteger:aVal]];
        [allNegative addObject:[NSNumber numberWithInteger:bVal]];
        [mixed addObject:[NSNumber numberWithInteger:cVal]];
    }
}

- (void)testCollect
{
    NSNumber *one = [NSNumber numberWithInteger:1];
    NSNumber *two = [NSNumber numberWithInteger:2];
    NSNumber *three = [NSNumber numberWithInteger:3];
    NSNumber *four = [NSNumber numberWithInteger:4];
    NSNumber *five = [NSNumber numberWithInteger:5];
    NSArray *a = [NSArray arrayWithObjects:one, two, three, four, five, nil];
    NSArray *collected = [a collect:^ id (id obj) {
        return [NSNumber numberWithInteger:[obj integerValue]+1];
    }];
    STAssertEquals([[collected objectAtIndex:0] integerValue], (NSInteger) 2, @"1 was not incremented");
    STAssertEquals([[collected objectAtIndex:1] integerValue], (NSInteger) 3, @"2 was not incremented");
    STAssertEquals([[collected objectAtIndex:2] integerValue], (NSInteger) 4, @"3 was not incremented");
    STAssertEquals([[collected objectAtIndex:3] integerValue], (NSInteger) 5, @"4 was not incremented");
    STAssertEquals([[collected objectAtIndex:4] integerValue], (NSInteger) 6, @"5 was not incremented");
}

- (void)testDetect
{
    NSNumber *negTwo = [NSNumber numberWithInteger:-2];
    NSNumber *zero = [NSNumber numberWithInteger:0];
    NSNumber *two = [NSNumber numberWithInteger:2];
    NSArray *a = [NSArray arrayWithObjects:negTwo, zero, two, nil];

    id detected = [a detect:^ BOOL (id obj) {
        return [obj integerValue] > 0;
    }];
    STAssertEquals([two integerValue], (NSInteger) 2, @"Found value was not 2");
    STAssertEqualObjects(two, detected, @"Found object is not the same as the one put into the array");

    id failed = [a detect:^ BOOL (id obj) { return [obj integerValue] >= 10; } ifNone:^ id { return [NSNumber numberWithInteger:100]; }];
    STAssertEquals([failed integerValue], (NSInteger) 100, @"Failed value is not 100");
    STAssertFalse([a containsObject:failed], @"array contains the failed object, but did not find it");
}

- (void)testInject
{
    NSNumber *one = [NSNumber numberWithInteger:1];
    NSNumber *two = [NSNumber numberWithInteger:2];
    NSNumber *three = [NSNumber numberWithInteger:3];
    NSArray *a = [NSArray arrayWithObjects:one, two, three, nil];
    id sum = [a inject:0 into:^ id (id memo, id obj) {
        NSInteger sum = [memo integerValue] + [obj integerValue];
        return [NSNumber numberWithInteger:sum];
    }];
    STAssertEquals([sum integerValue], (NSInteger) 6, @"sum of 1+2+3 should be 6");
}

- (void)testReject
{
    NSArray *a = [NSArray arrayWithObjects:@"prefix", @"suffix", @"nothing", @"something else", nil];
    NSArray *target = [NSArray arrayWithObjects:@"nothing", @"something else", nil];
    NSArray *returned = [a reject:^ BOOL (id obj) {
        return [obj rangeOfString:@"fix"].location == [obj length]-[@"fix" length];
    }];
    STAssertTrue([returned isEqualToArray:target], @"'reject:' did not return strings without the suffix 'fix'");
}

- (void)testSelect
{
    NSArray *a = [NSArray arrayWithObjects:@"prefix", @"suffix", @"nothing", @"something else", nil];
    NSArray *target = [NSArray arrayWithObjects:@"prefix", @"suffix", nil];
    NSArray *returned = [a select:^ BOOL (id obj) {
        return [obj rangeOfString:@"fix"].location == [obj length] - [@"fix" length];
    }];
    STAssertTrue([returned isEqualToArray:target], @"'select:' did not return strings with the suffix 'fix'");
}

- (void)testAll
{
    BOOL (^test)(id obj) = ^ BOOL (id obj) { return [obj integerValue] > 0; };
    STAssertTrue([allPositive all:test], @"All of the values should be > 0");
    STAssertFalse([allNegative all:test], @"Some values should be <= 0");
    STAssertFalse([mixed all:test], @"Some values should be <= 0");
}

- (void)testAny
{
    BOOL (^test)(id obj) = ^ BOOL (id obj) { return [obj integerValue] > 0; };
    STAssertTrue([allPositive any:test], @"At least one value shoud be > 0");
    STAssertFalse([allNegative any:test], @"No values should be > 0");
    STAssertTrue([mixed any:test], @"At least one value should be > 0");
}

- (void)testNone
{
    BOOL (^test)(id obj) = ^ BOOL (id obj) { return [obj integerValue] > 0; };
    STAssertFalse([allPositive none:test], @"At least one value should be > 0");
    STAssertTrue([allNegative none:test], @"No values should be > 0");
    STAssertFalse([mixed none:test], @"Some values should be > 0");
}

- (void)testOne
{
    NSMutableArray *justOne = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 10; i++) {
        NSInteger val = i == 5 ? 5 : -i;
        [justOne addObject:[NSNumber numberWithInteger:val]];
    }

    BOOL (^test)(id obj) = ^ BOOL (id obj) { return [obj integerValue] > 0; };
    STAssertFalse([allPositive one:test], @"Only one value should be > 0");
    STAssertFalse([allNegative one:test], @"Only one value should be > 0");
    STAssertFalse([mixed one:test], @"Only one value should be > 0");
    STAssertTrue([justOne one:test], @"Only one is > 0");
}

- (void)testDrop
{
    NSInteger n = 5;
    NSMutableArray *cmp = [NSMutableArray arrayWithCapacity:[allPositive count]-n];
    for (NSInteger i = n; i < [allPositive count]; i++) {
        [cmp addObject:[allPositive objectAtIndex:i]];
    }
    NSArray *dropped = [allPositive drop:n];
    STAssertEquals([dropped count], [allPositive count]-n, @"Did not drop %d elements", n);
    STAssertEquals([dropped count], [cmp count], @"Did not drop %d elements", n);
    STAssertTrue([dropped isEqualToArray:cmp], @"Arrays are not equal");
}

- (void)testDropWhile
{
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:6];
    for (NSUInteger i = 1U; i <= 5; i++) {
        [a addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    [a addObject:[NSNumber numberWithUnsignedInteger:0U]];

    NSMutableArray *target = [NSMutableArray arrayWithCapacity:4];
    for (NSUInteger i = 3U; i <= 5; i++) {
        [target addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    [target addObject:[NSNumber numberWithUnsignedInteger:0U]];

    NSArray *dropped = [a dropWhile:^ BOOL (id obj) { return [obj integerValue] < 3; }];
    STAssertEquals([dropped count], [target count], @"Arrays are not the same size (is %u, should be %u)", [dropped count], [target count]);
    for (NSUInteger i = 0U; i < [dropped count]; i++) {
        NSInteger this = [[dropped objectAtIndex:i] integerValue];
        NSInteger that = [[target objectAtIndex:i] integerValue];
        STAssertEquals(this, that, @"Integers are not the same value (is %d, should be %d)", this, that);
    }
}

- (void)testMax
{
    NSArray *a = [NSArray arrayWithObjects:@"foo", @"bar", @"max", @"baz", nil];
    id max = [a max:^ NSComparisonResult (id left, id right) { return [left compare:right]; }];
    STAssertEqualObjects(max, @"max", @"maximum value was not 'max' (was '%@')", max);
}

- (void)testMin
{
    NSArray *a = [NSArray arrayWithObjects:@"foo", @"bar", @"max", @"baz", nil];
    id min = [a min:^ NSComparisonResult (id left, id right) { return [left compare:right]; }];
    STAssertEqualObjects(min, @"bar", @"minimum value was not 'bar' (was '%@')", min);
}

- (void)testPartition
{
    NSMutableArray *evens = [NSMutableArray arrayWithCapacity:[allPositive count]/2];
    NSMutableArray *odds = [NSMutableArray arrayWithCapacity:[allPositive count]/2];
    for (NSUInteger i = 1; i <= 10; i++) {
        if (i % 2 == 0) {
            [evens addObject:[NSNumber numberWithUnsignedInteger:i]];
        } else {
            [odds addObject:[NSNumber numberWithUnsignedInteger:i]];
        }
    }

    NSArray *partition = [allPositive partition:^ BOOL (id obj) { return [obj integerValue] % 2 == 0; }];
    STAssertEquals([partition count], (NSUInteger) 2U, @"partition should consist of two arrays");
    NSArray *retEvens = [partition objectAtIndex:0];
    NSArray *retOdds = [partition objectAtIndex:1];
    STAssertEquals([retEvens count], [evens count], @"returned evens is not same size as evens");
    STAssertEquals([retOdds count], [odds count], @"returned odds is not same size as odds");
    for (NSUInteger i = 0U; i < [retEvens count]; i++) {
        NSInteger this = [[retEvens objectAtIndex:i] integerValue];
        NSInteger that = [[evens objectAtIndex:i] integerValue];
        STAssertEquals(this, that, @"Integers are not equal (is %d, should be %d)", this, that);
    }
    for (NSUInteger i = 0U; i < [retOdds count]; i++) {
        NSInteger this = [[retOdds objectAtIndex:i] integerValue];
        NSInteger that = [[odds objectAtIndex:i] integerValue];
        STAssertEquals(this, that, @"Integers are not equal (is %d, should be %d)", this, that);
    }
}

- (void)testTake
{
    NSUInteger n = 2;
    NSMutableArray *target = [NSMutableArray arrayWithCapacity:n];
    for (NSUInteger i = 0U; i < n; i++) {
        [target addObject:[allPositive objectAtIndex:i]];
    }
    
    NSArray *f = [allPositive take:n];
    STAssertEquals([f count], [target count], @"Arrays are not the same size (is %u, should be %u)", [f count], [target count]);
    for (NSUInteger i = 0U; i < [f count]; i++) {
        NSInteger this = [[f objectAtIndex:i] integerValue];
        NSInteger that = [[target objectAtIndex:i] integerValue];
        STAssertEquals(this, that, @"Integers are not the same value (is %d, should be %d)", this, that);
    }
}

- (void)testTakeWhile
{
    NSArray *a = [NSArray arrayWithObjects:@"red", @"orange", @"yellow", @"green", @"stop", @"blue", @"indigo", @"violet", nil];
    NSArray *target = [NSArray arrayWithObjects:@"red", @"orange", @"yellow", @"green", nil];
    NSArray *taken = [a takeWhile:^ BOOL (id obj) { return ![obj isEqualToString:@"stop"]; }];
    STAssertTrue([taken isEqualToArray:target], @"Arrays do not have the same elements");
}

- (void)tearDown
{
    [allPositive release]; allPositive = nil;
    [allNegative release]; allNegative = nil;
    [mixed release]; mixed = nil;
}

@end
