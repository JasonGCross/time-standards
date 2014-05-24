//
//  STSTimeStandardTableCell.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/14/14.
//
//

#import "STSTimeStandardHomeScreenTableCell.h"

@implementation STSTimeStandardHomeScreenTableCell

+ (NSString *)cellIdentifier {
    static NSString* _cellIdentifier = nil;
    _cellIdentifier = NSStringFromClass([self class]);
    return _cellIdentifier;
}

- (void)awakeFromNib
{
    NSLog(@"awake from nib");
}

@end
