/* A useful programming for stepping through library code in a debugger. */

#import <Foundation/Foundation.h>
#import "NSArrayCollections.h"

#include <stdio.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray *a = [NSArray arrayWithObjects:@"foo", @"bar", @"max", @"baz", @"something else", nil];
    id min = [a min:^ NSComparisonResult (id left, id right) { return [left compare:right]; }];
    printf("Min is: %s\n", [min UTF8String]);
    [pool release];
    return 0;
}
