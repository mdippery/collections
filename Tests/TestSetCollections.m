#import "TestSetCollections.h"
#import "MDPair.h"
#import "NSSet+Collections.h"

#include <ctype.h>


@implementation TestSetCollections

- (void)setUp
{
    animalSet = [[NSSet alloc] initWithObjects:@"aardvark", @"anteater", @"zebra", nil];
    setA = [[NSSet alloc] initWithObjects:@"aardvark", @"anteater", nil];
    setZ = [[NSSet alloc] initWithObjects:@"zebra", nil];
    startsWithA = [^ BOOL (id obj) { return [obj hasPrefix:@"a"]; } copy];
}

- (void)testDo
{
    NSMutableString *str = [NSMutableString stringWithString:@"awesome"];
    NSSet *orig = [NSSet setWithObject:str];
    NSSet *s = [orig do:^ (id obj) { [obj appendString:@" possum"]; }];
    NSString *tstr = [s anyObject];
    XCTAssertTrue([tstr isEqualToString:@"awesome possum"], @"Transformed string should be 'awesome possum' (is '%@')", tstr);
}

- (void)testCollect
{
    NSSet *s = [animalSet collect:^ id (id obj) { return [obj uppercaseString]; }];
    NSString *test = [s anyObject];
    for (NSUInteger i = 0U; i < [test length]; i++) {
        unichar ch = [test characterAtIndex:i];
        XCTAssertTrue(isupper(ch), @"%c should be uppercase, but is not", ch);
    }
}

- (void)testInject
{
    NSNumber *zero = [NSNumber numberWithInteger:0];
    NSNumber *one = [NSNumber numberWithInteger:1];
    NSNumber *two = [NSNumber numberWithInteger:2];
    NSNumber *three = [NSNumber numberWithInteger:3];
    NSSet *orig = [NSSet setWithObjects:one, two, three, nil];
    NSNumber *sum = [orig inject:zero into:^ id (id memo, id obj) {
        NSInteger this = [memo integerValue];
        NSInteger that = [obj integerValue];
        return [NSNumber numberWithInteger:this+that];
    }];
    XCTAssertEqual([sum integerValue], (NSInteger) 6, @"Sum should be 6, is %ld", (long)[sum integerValue]);
}

- (void)testReject
{
    NSSet *rejected = [animalSet reject:^ BOOL (id obj) { return ![obj hasPrefix:@"a"]; }];
    XCTAssertEqual([rejected count], (NSUInteger) 2, @"Filtered set should have 2 elements (has %lu)", (unsigned long)[rejected count]);
    XCTAssertTrue([[rejected anyObject] hasPrefix:@"a"], @"All items in filtered set should start with 'a'");
}

- (void)testSelect
{
    NSSet *selected = [animalSet select:^ BOOL (id obj) { return [obj hasPrefix:@"z"]; }];
    XCTAssertEqual([selected count], (NSUInteger) 1, @"Filtered set should have 1 element (has %lu)", (unsigned long)[selected count]);
    XCTAssertTrue([[selected anyObject] hasPrefix:@"z"], @"Filtered set should only contain elements that begin with 'z'");
}

- (void)testAll
{
    XCTAssertFalse([animalSet all:startsWithA], @"Not all objects in animalSet begin with 'a'");
    XCTAssertTrue([setA all:startsWithA], @"All objects in setA begin with 'a'");
    XCTAssertFalse([setZ all:startsWithA], @"No objects in setZ begin with 'a'");
}

- (void)testAny
{
    XCTAssertTrue([animalSet any:startsWithA], @"Some objects in animalSet begin with 'a'");
    XCTAssertTrue([setA any:startsWithA], @"All objects in setA begin with 'a'");
    XCTAssertFalse([setZ all:startsWithA], @"No objects in setZ begin with 'a'");
}

- (void)testNone
{
    XCTAssertFalse([animalSet none:startsWithA], @"Some objects in animalSet begin with 'a'");
    XCTAssertFalse([setA none:startsWithA], @"All objects in animalSet begin with 'a'");
    XCTAssertTrue([setZ none:startsWithA], @"No objects in setZ begin with 'a'");
}

- (void)testOne
{
    BoolTestBlock startsWithZ = ^ BOOL (id obj) { return [obj hasPrefix:@"z"]; };
    XCTAssertFalse([animalSet one:startsWithA], @"More than one object in animalSet begins with 'a'");
    XCTAssertFalse([setA one:startsWithA], @"Only one object in setA begin with 'a'");
    XCTAssertFalse([setZ one:startsWithA], @"No objects in setZ begin with 'a'");
    XCTAssertTrue([animalSet one:startsWithZ], @"Only one object in animalSet begins with 'z'");
}

- (void)testMax
{
    NSString *max = [animalSet max:^ NSComparisonResult (id left, id right) { return [left compare:right]; }];
    XCTAssertTrue([max isEqualToString:@"zebra"], @"Max string should be 'zebra', is '%@'", max);
}

- (void)testMin
{
    NSString *min = [animalSet min:^ NSComparisonResult (id left, id right) { return [left compare:right]; }];
    XCTAssertTrue([min isEqualToString:@"aardvark"], @"Min string should be 'aardvark', is '%@'", min);
}

- (void)testPartition
{
    MDPair *partition = [animalSet partition:startsWithA];
    NSSet *t = [partition firstObject];
    NSSet *f = [partition secondObject];
    XCTAssertEqual([t count], (NSUInteger) 2U, @"There should be two objects that start with 'a'.");
    XCTAssertEqual([f count], (NSUInteger) 1U, @"There should be one object that starts with 'a'.");
    XCTAssertTrue([t containsObject:@"aardvark"], @"True values should include 'aardvark'.");
    XCTAssertTrue([t containsObject:@"anteater"], @"True values should include 'anteater.'");
    XCTAssertTrue([f containsObject:@"zebra"], @"False values should include 'zebra'.");
}

- (void)tearDown
{
    [animalSet release]; animalSet = nil;
    [setA release]; setA = nil;
    [setZ release]; setZ = nil;
    [startsWithA release];
}

@end
