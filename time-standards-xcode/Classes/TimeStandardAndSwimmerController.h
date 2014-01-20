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
    HomeScreenViewController_ipad * __weak homeScreenVC;
    UIPopoverController           * popoverController;
    
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

@property (nonatomic, weak) IBOutlet HomeScreenViewController_ipad * homeScreenVC;
@property (nonatomic, strong) UIPopoverController * popoverController;

// time standards
@property (nonatomic, strong) NSString * timeStandardSettingLabelText;
@property (nonatomic, strong) NSString * settingValue;

// swimmer controller
@property (nonatomic, strong) NSString * swimmerSettingLabelText;
@property (nonatomic, strong) IBOutlet UITableViewCell * nibLoadedSwimmerCell;
@property (nonatomic, strong) IBOutlet UITableViewCell * nibLoadedSwimmerCellEditingView;
@property (weak, nonatomic, readonly) NSManagedObjectContext * managedObjectContext;
@property (weak, nonatomic, readonly) NSFetchedResultsController * fetchedResultsController;
@property (nonatomic, strong) UIBarButtonItem * addButton;

- (IBAction) handleEditTapped;
- (IBAction) handleAddTapped;


@end
