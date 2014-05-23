//
//  STSSwimmerListTableViewCell+Binding.h
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/14/14.
//
//

#import "STSSwimmerListTableViewCell.h"

@class NSManagedObject;

@interface STSSwimmerListTableViewCell (Binding)
- (void) bindToSwimmer:(NSManagedObject *) swimmer;
@end
