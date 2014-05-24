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
    NSString * swimmerName = [swimmer valueForKey:@"swimmerName"];
    swimmerName = ([NSString sts_isEmpty:swimmerName]) ? @"select a swimmer" : swimmerName;
    self.swimmerNameLabel.text = swimmerName;
    
    NSMutableString * swimmerDescription = [NSMutableString stringWithCapacity:20];
    NSString * swimmerAgeGroup = [swimmer valueForKey:@"swimmerAgeGroup"];
    swimmerAgeGroup = ([NSString sts_isEmpty:swimmerAgeGroup]) ? @"(re)select age group" : swimmerAgeGroup;
    [swimmerDescription appendString:swimmerAgeGroup];
    [swimmerDescription appendString:@" "];
    
    NSString * swimmerGender = [swimmer valueForKey:@"swimmerGender"];
    swimmerGender = ([NSString sts_isEmpty:swimmerGender]) ? @"select gender" : swimmerGender;
    [swimmerDescription appendString:swimmerGender];
    self.swimmerDescriptionLabel.text = swimmerDescription;
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
