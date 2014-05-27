//
//  STSSwimmerListTableViewCell+Binding.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/14/14.
//
//

#import "STSSwimmerListTableViewCell+Binding.h"


@implementation STSSwimmerListTableViewCell (Binding)

- (void) bindToSwimmer:(NSManagedObject *) swimmer; {
    self.swimmerNameLabel.text = [swimmer valueForKey:@"swimmerName"];
    
    NSString * swimmerGender = [swimmer valueForKey:@"swimmerGender"];
    self.swimmerGenderLabel.text = (swimmerGender == nil) ? @"select gender" : swimmerGender;
    
    NSString * swimmerAgeGroup = [swimmer valueForKey:@"swimmerAgeGroup"];
    self.swimmerAgeGroupLabel.text = (swimmerAgeGroup == nil) ? @"select age group" : swimmerAgeGroup;
    
    if(swimmer != nil) {
		NSManagedObject * photo = [swimmer valueForKey:@"swimmerThumbnailPhoto"];
		UIImage * image;
		if (photo != nil) {
			image = [photo valueForKey:@"photoImage"];
			if (image != nil) {
				self.photoImageView.image = image;
			}
		}
		else {
			image = [UIImage imageNamed:STSImageThumnailName];
			self.photoImageView.image = image;
		}
	}
    
    self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}

@end
