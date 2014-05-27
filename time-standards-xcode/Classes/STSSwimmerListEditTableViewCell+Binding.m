//
//  STSSwimmerListEditTableViewCell+Binding.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 5/26/14.
//
//

#import "STSSwimmerListEditTableViewCell+Binding.h"
#import "STSSwimmerListTableViewCell+Binding.h"

@implementation STSSwimmerListEditTableViewCell (Binding)

- (void) bindToSwimmer:(NSManagedObject *) swimmer;{
    [super bindToSwimmer:swimmer];
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end
