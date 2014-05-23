//
//  STSTimeStandardHomeScreenTableCell+Binding.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/14/14.
//
//

#import "STSTimeStandardHomeScreenTableCell+Binding.h"
#import "STSSwimmerDataAccess.h"


@implementation STSTimeStandardHomeScreenTableCell (Binding)

- (void) bind; {
    NSString * timeStandardName = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenTimeStandard];
    self.standardNameLabel.text = timeStandardName;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
