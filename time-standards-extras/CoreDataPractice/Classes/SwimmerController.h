//
//  SwimmerController.h
//  CoreDataPractice
//
//  Created by JASON CROSS on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoreDataPracticeAppDelegate;


@interface SwimmerController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSString 		   * settingLabelText;
	UITableViewCell    * nibLoadedSwimmerCell;
	UITableViewCell    * nibLoadedSwimmerCellEditingView;
	UIColor			   * defaultTintColor;
	UISegmentedControl * segmentedControl;
	CoreDataPracticeAppDelegate * appDelegate;
	NSManagedObjectContext * managedObjectContext;
	NSFetchedResultsController * fetchedResultsController;
}

@property (nonatomic, retain) NSString * settingLabelText;
@property (nonatomic, retain) IBOutlet UITableViewCell * nibLoadedSwimmerCell;
@property (nonatomic, retain) IBOutlet UITableViewCell * nibLoadedSwimmerCellEditingView;
@property (nonatomic, retain) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsController;

- (IBAction) handleSegmentedControllerChanged: (id) sender;
- (IBAction) handleEditTapped;
- (IBAction) handleAddTapped;

@end
