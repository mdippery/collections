#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>


typedef BOOL (^BoolTestBlock)(id);

@interface TestSetCollections : XCTestCase
{
    NSSet *animalSet;
    NSSet *setA;
    NSSet *setZ;
    BoolTestBlock startsWithA;
}
@end
