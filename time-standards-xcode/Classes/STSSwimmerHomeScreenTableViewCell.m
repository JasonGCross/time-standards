//
//  STSSwimmerTableViewCell.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/14/14.
//
//

#import "STSSwimmerHomeScreenTableViewCell.h"

@implementation STSSwimmerHomeScreenTableViewCell

+ (NSString *)cellIdentifier {
    static NSString* _cellIdentifier = nil;
    _cellIdentifier = NSStringFromClass([self class]);
    return _cellIdentifier;
}

@end
