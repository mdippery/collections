#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>


typedef BOOL (^BoolTestBlock)(id);

@interface TestSetCollections : SenTestCase
{
    NSSet *animalSet;
    NSSet *setA;
    NSSet *setZ;
    BoolTestBlock startsWithA;
}
@end
