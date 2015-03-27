#import "TestDictionaryCollections.h"
#import "NSDictionary+Collections.h"

#include <ctype.h>


@implementation TestDictionaryCollections

- (void)setUp
{
    NSArray *animals = [NSArray arrayWithObjects:@"anteaters", @"humans", @"deer", @"owls", nil];
    NSArray *food = [NSArray arrayWithObjects:@"ants", @"anything", @"plants", @"mice", nil];
    NSArray *states = [NSArray arrayWithObjects:@"Pennsylvania", @"New York", @"Virginia", nil];
    NSArray *codes = [NSArray arrayWithObjects:@"pa", @"ny", @"va", nil];
    eats = [[NSDictionary alloc] initWithObjects:food forKeys:animals];
    postalCodes = [[NSDictionary alloc] initWithObjects:codes forKeys:states];
}

- (void)testDo
{
    NSString *target = @"I have lived in X, X, and X.";
    __block NSMutableString *places = [NSMutableString stringWithString:@"I have lived in"];
    __block int i = 1;
    NSArray *states = [NSArray arrayWithObjects:@"Pennsylvania", @"New York", @"Virginia", nil];
    NSArray *abbrevs = [NSArray arrayWithObjects:@"PA", @"NY", @"VA", nil];
    NSDictionary *data = [NSDictionary dictionaryWithObjects:abbrevs forKeys:states];
    [data do:^ (id obj) {
        if (i == 1) {
            [places appendString:@" X"];
        } else if (i == 2) {
            [places appendString:@", X"];
        } else {
            [places appendString:@", and X."];
        }
        i++;
    }];
    XCTAssertTrue([places isEqualToString:target], @"String should be '%@', is '%@'", target, places);
}

- (void)testCollect
{
    NSDictionary *d = [postalCodes collect:^ id (id s) { return [s uppercaseString]; }];
    for (NSString *key in d) {
        NSString *code = [d objectForKey:key];
        for (NSUInteger i = 0U; i < [code length]; i++) {
            XCTAssertTrue(isupper([code characterAtIndex:i]), @"'%@' does not consist entirely of uppercase letters", code);
        }
    }
}

- (void)testInject
{
    NSString *s = @"I have lived in: ";
    __block BOOL first = YES;
    NSString *sout = [postalCodes inject:s into:^ id (id memo, id obj) {
        if (!first) memo = [memo stringByAppendingString:@", "];
        memo = [memo stringByAppendingString:obj];
        first = NO;
        return memo;
    }];
    XCTAssertEqual([sout length], (NSUInteger) 27U, @"Output is '%@'", sout);
}

- (void)testReject
{
    NSSet *targets = [NSSet setWithObjects:@"ants", @"anything", nil];
    NSDictionary *d = [eats reject:^ BOOL (id obj) { return ![obj hasPrefix:@"a"]; }];
    XCTAssertEqual([d count], [targets count], @"Dictionary should have %lu elements, has %lu", (unsigned long)[targets count], (unsigned long)[d count]);
    for (NSString *key in d) {
        NSString *food = [d objectForKey:key];
        XCTAssertTrue([targets containsObject:food], @"target should contain the object %@", food);
    }
}

- (void)testSelect
{
    NSSet *targets = [NSSet setWithObjects:@"ants", @"anything", nil];
    NSDictionary *d = [eats select:^ BOOL (id obj) { return [obj hasPrefix:@"a"]; }];
    XCTAssertEqual([d count], [targets count], @"Dictionary should have %lu elements, has %lu", (unsigned long)[targets count], (unsigned long)[d count]);
    for (NSString *key in d) {
        NSString *food = [d objectForKey:key];
        XCTAssertTrue([targets containsObject:food], @"target should contain the object %@", food);
    }
}


- (void)tearDown
{
    [postalCodes release]; postalCodes = nil;
    [eats release]; eats = nil;
}

@end
