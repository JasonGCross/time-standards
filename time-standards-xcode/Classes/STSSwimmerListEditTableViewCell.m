//
//  STSSwimmerListEditTableViewCell.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/14/14.
//
//

#import "STSSwimmerListEditTableViewCell.h"

@implementation STSSwimmerListEditTableViewCell

+ (NSString *)cellIdentifier {
    static NSString* _cellIdentifier = nil;
    _cellIdentifier = NSStringFromClass([self class]);
    return _cellIdentifier;
}


@end
