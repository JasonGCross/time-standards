//
//  STSSwimmerHomeScreenTableViewCell+Binding.h
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/14/14.
//
//

#import "STSSwimmerHomeScreenTableViewCell.h"

@class NSManagedObject;

@interface STSSwimmerHomeScreenTableViewCell (Binding)
- (void) bindToSwimmer:(NSManagedObject*)swimmer;
@end
