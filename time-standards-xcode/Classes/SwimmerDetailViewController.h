//
//  SwimmerDetailViewController.h
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwimmingTimesStandardsGlobals.h"

@class SwimmingTimeStandardsAppDelegate;


@interface SwimmerDetailViewController : UIViewController <UITextFieldDelegate, 
UITableViewDelegate, UITableViewDataSource> {
	NSManagedObject * swimmer;
	NSArray			* genderList;
	NSArray			* ageList;
	NSIndexPath		* lastGenderPath;
	NSIndexPath		* lastAgeGroupPath;
	UITextField		* nameTextField;
	UIImageView		* imageView;
	SwimmingTimeStandardsAppDelegate * appDelegate;
}

@property (nonatomic, retain) IBOutlet UITextField * nameTextField;
@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;

- (IBAction) backgroundTapped:(id)sender;
- (IBAction) imageViewTapped:(id)sender;
- (IBAction) textFieldDoneEditing:(id)sender;

@end
