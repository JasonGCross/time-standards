//
//  SwimmerController.h
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STSAppDelegate;

@interface STSSwimmerController : UITableViewController <NSFetchedResultsControllerDelegate> 
@property (nonatomic, strong) NSString * settingLabelText;
@property (weak, nonatomic, readonly) NSManagedObjectContext * managedObjectContext;
@property (weak, nonatomic, readonly) NSFetchedResultsController * fetchedResultsController;

- (IBAction) handleSegmentedControllerChanged: (id) sender;
- (IBAction) handleEditTapped;
- (IBAction) handleAddTapped;

@end
