//
//  SwimmerDetailViewController.h
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwimmingTimesStandardsGlobals.h"


@interface SwimmerDetailViewController : UIViewController <UITextFieldDelegate, 
UITableViewDelegate, UITableViewDataSource> {
	NSManagedObject * swimmer;
	NSArray			* genderList;
	NSArray			* ageList;
	NSIndexPath		* lastGenderPath;
	NSIndexPath		* lastAgeGroupPath;
	UITextField		* nameTextField;
	UITableView		* tableView;
	UITableViewCell * nibLoadedSwimmerNameCell;
	UIImageView		* imageView;
}

@property (nonatomic, retain) NSManagedObject * swimmer;
@property (nonatomic, retain) IBOutlet UITextField * nameTextField;
@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) IBOutlet UITableViewCell * nibLoadedSwimmerNameCell;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;

- (IBAction) textFieldDoneEditing:(id)sender;
- (IBAction) backgroundTapped:(id)sender;
- (IBAction) imageViewTapped:(id)sender;

@end
