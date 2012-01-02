//
//  TimeStandardAndSwimmerController.h
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SwimmingTimeStandardsAppDelegate;
@class HomeScreenViewController_ipad;


@interface TimeStandardAndSwimmerController : UITableViewController <NSFetchedResultsControllerDelegate> {
    HomeScreenViewController_ipad * homeScreenVC;
    
    // time standards
    NSString 		* timeStandardSettingLabelText;
	NSString		* settingValue;
	NSArray 	    * _settingList;
	NSIndexPath		* _lastIndexPath;
    
    // swimmer controller
    NSString 		   * swimmerSettingLabelText;
	UITableViewCell    * nibLoadedSwimmerCell;
	UITableViewCell    * nibLoadedSwimmerCellEditingView;
	UIColor			   * _defaultTintColor;
	UISegmentedControl * segmentedControl;
	SwimmingTimeStandardsAppDelegate * appDelegate;
	NSManagedObjectContext * managedObjectContext_;
	NSFetchedResultsController * fetchedResultsController_;
    UIBarButtonItem * addButton;
}

@property (nonatomic, assign) IBOutlet HomeScreenViewController_ipad * homeScreenVC;

// time standards
@property (nonatomic, retain) NSString * timeStandardSettingLabelText;
@property (nonatomic, retain) NSString * settingValue;

// swimmer controller
@property (nonatomic, retain) NSString * swimmerSettingLabelText;
@property (nonatomic, retain) IBOutlet UITableViewCell * nibLoadedSwimmerCell;
@property (nonatomic, retain) IBOutlet UITableViewCell * nibLoadedSwimmerCellEditingView;
@property (nonatomic, readonly) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, readonly) NSFetchedResultsController * fetchedResultsController;
@property (nonatomic, retain) UIBarButtonItem * addButton;

- (IBAction) handleEditTapped;
- (IBAction) handleAddTapped;


@end
