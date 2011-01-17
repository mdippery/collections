#import "TestSetCollections.h"
#import "MDPair.h"
#import "NSSetCollections.h"

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
    STAssertTrue([tstr isEqualToString:@"awesome possum"], @"Transformed string should be 'awesome possum' (is '%@')", tstr);
}

- (void)testCollect
{
    NSSet *s = [animalSet collect:^ id (id obj) { return [obj uppercaseString]; }];
    NSString *test = [s anyObject];
    for (NSUInteger i = 0U; i < [test length]; i++) {
        unichar ch = [test characterAtIndex:i];
        STAssertTrue(isupper(ch), @"%c should be uppercase, but is not", ch);
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
    STAssertEquals([sum integerValue], (NSInteger) 6, @"Sum should be 6, is %d", [sum integerValue]);
}

- (void)testReject
{
    NSSet *rejected = [animalSet reject:^ BOOL (id obj) { return ![obj hasPrefix:@"a"]; }];
    STAssertEquals([rejected count], (NSUInteger) 2, @"Filtered set should have 2 elements (has %u)", [rejected count]);
    STAssertTrue([[rejected anyObject] hasPrefix:@"a"], @"All items in filtered set should start with 'a'");
}

- (void)testSelect
{
    NSSet *selected = [animalSet select:^ BOOL (id obj) { return [obj hasPrefix:@"z"]; }];
    STAssertEquals([selected count], (NSUInteger) 1, @"Filtered set should have 1 element (has %u)", [selected count]);
    STAssertTrue([[selected anyObject] hasPrefix:@"z"], @"Filtered set should only contain elements that begin with 'z'");
}

- (void)testAll
{
    STAssertFalse([animalSet all:startsWithA], @"Not all objects in animalSet begin with 'a'");
    STAssertTrue([setA all:startsWithA], @"All objects in setA begin with 'a'");
    STAssertFalse([setZ all:startsWithA], @"No objects in setZ begin with 'a'");
}

- (void)testAny
{
    STAssertTrue([animalSet any:startsWithA], @"Some objects in animalSet begin with 'a'");
    STAssertTrue([setA any:startsWithA], @"All objects in setA begin with 'a'");
    STAssertFalse([setZ all:startsWithA], @"No objects in setZ begin with 'a'");
}

- (void)testNone
{
    STAssertFalse([animalSet none:startsWithA], @"Some objects in animalSet begin with 'a'");
    STAssertFalse([setA none:startsWithA], @"All objects in animalSet begin with 'a'");
    STAssertTrue([setZ none:startsWithA], @"No objects in setZ begin with 'a'");
}

- (void)testOne
{
    BoolTestBlock startsWithZ = ^ BOOL (id obj) { return [obj hasPrefix:@"z"]; };
    STAssertFalse([animalSet one:startsWithA], @"More than one object in animalSet begins with 'a'");
    STAssertFalse([setA one:startsWithA], @"Only one object in setA begin with 'a'");
    STAssertFalse([setZ one:startsWithA], @"No objects in setZ begin with 'a'");
    STAssertTrue([animalSet one:startsWithZ], @"Only one object in animalSet begins with 'z'");
}

- (void)testMax
{
    NSString *max = [animalSet max:^ NSComparisonResult (id left, id right) { return [left compare:right]; }];
    STAssertTrue([max isEqualToString:@"zebra"], @"Max string should be 'zebra', is '%@'", max);
}

- (void)testMin
{
    NSString *min = [animalSet min:^ NSComparisonResult (id left, id right) { return [left compare:right]; }];
    STAssertTrue([min isEqualToString:@"aardvark"], @"Min string should be 'aardvark', is '%@'", min);
}

- (void)testPartition
{
    MDPair *partition = [animalSet partition:startsWithA];
    NSSet *t = [partition firstObject];
    NSSet *f = [partition secondObject];
    STAssertEquals([t count], (NSUInteger) 2U, @"There should be two objects that start with 'a'.");
    STAssertEquals([f count], (NSUInteger) 1U, @"There should be one object that starts with 'a'.");
    STAssertTrue([t containsObject:@"aardvark"], @"True values should include 'aardvark'.");
    STAssertTrue([t containsObject:@"anteater"], @"True values should include 'anteater.'");
    STAssertTrue([f containsObject:@"zebra"], @"False values should include 'zebra'.");
}

- (void)tearDown
{
    [animalSet release]; animalSet = nil;
    [setA release]; setA = nil;
    [setZ release]; setZ = nil;
    [startsWithA release];
}

@end
