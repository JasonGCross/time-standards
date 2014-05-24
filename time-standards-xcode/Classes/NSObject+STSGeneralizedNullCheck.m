//
//  NSObject+STSGeneralizedNullCheck.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 5/23/14.
//
//

#import "NSObject+STSGeneralizedNullCheck.h"

@implementation NSObject (STSGeneralizedNullCheck)

+ (BOOL) sts_isEmpty: (id) thing; {
    return (thing == nil) || (thing == [NSNull null])
    || ([thing respondsToSelector:@selector(length)] && ([(NSData *)thing length] == 0))
    || ([thing respondsToSelector:@selector(count)] && ([(NSArray *)thing count] == 0));
}

@end
