//
//  SwimmerController.h
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwimmingTimeStandardsAppDelegate;

@interface SwimmerController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSString 		   * settingLabelText;
	UITableViewCell    * nibLoadedSwimmerCell;
	UITableViewCell    * nibLoadedSwimmerCellEditingView;
	UIColor			   * _defaultTintColor;
	UISegmentedControl * segmentedControl;
	SwimmingTimeStandardsAppDelegate * appDelegate;
	NSManagedObjectContext * managedObjectContext_;
	NSFetchedResultsController * fetchedResultsController_;
}

@property (nonatomic, strong) NSString * settingLabelText;
@property (nonatomic, strong) IBOutlet UITableViewCell * nibLoadedSwimmerCell;
@property (nonatomic, strong) IBOutlet UITableViewCell * nibLoadedSwimmerCellEditingView;
@property (weak, nonatomic, readonly) NSManagedObjectContext * managedObjectContext;
@property (weak, nonatomic, readonly) NSFetchedResultsController * fetchedResultsController;

- (IBAction) handleSegmentedControllerChanged: (id) sender;
- (IBAction) handleEditTapped;
- (IBAction) handleAddTapped;

@end
