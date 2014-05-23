//
//  STSSwimmerHomeScreenTableViewCell+Binding.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/14/14.
//
//

#import "STSSwimmerHomeScreenTableViewCell+Binding.h"

@implementation STSSwimmerHomeScreenTableViewCell (Binding)


- (void) bindToSwimmer:(NSManagedObject*)swimmer; {
    self.swimmerNameLabel.text = [swimmer valueForKey:@"swimmerName"];
    
    NSMutableString * swimmerDescription = [NSMutableString stringWithCapacity:20];
    NSString * swimmerAgeGroup = [swimmer valueForKey:@"swimmerAgeGroup"];
    swimmerAgeGroup = (swimmerAgeGroup == nil) ? @"(re)select age group" : swimmerAgeGroup;
    [swimmerDescription appendString:swimmerAgeGroup];
    [swimmerDescription appendString:@" "];
    
    NSString * swimmerGender = [swimmer valueForKey:@"swimmerGender"];
    swimmerGender = (swimmerGender == nil) ? @"select gender" : swimmerGender;
    [swimmerDescription appendString:swimmerGender];
    self.swimmerDescriptionLabel.text = swimmerDescription;
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
