//
//  SwimmerDetailViewController.h
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwimmingTimeStandardsAppDelegate;


@interface SwimmerDetailViewController : UIViewController <UITextFieldDelegate, 
UITableViewDelegate, UITableViewDataSource> {
	NSManagedObject * _swimmer;
	NSArray			* _genderList;
	NSArray			* _ageList;
	NSIndexPath		* _lastGenderPath;
	NSIndexPath		* _lastAgeGroupPath;
	UITextField		* nameTextField;
	UIImageView		* imageView;
	SwimmingTimeStandardsAppDelegate * _appDelegate;
    
    NSString        * _initialGender;
    NSString        * _initialAge;
}

@property (nonatomic, strong) IBOutlet UITextField * nameTextField;
@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet UIImageView * imageView;

- (IBAction) backgroundTapped:(id)sender;
- (IBAction) imageViewTapped:(id)sender;
- (IBAction) textFieldDoneEditing:(id)sender;

@end
