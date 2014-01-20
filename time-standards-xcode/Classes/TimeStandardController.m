//
//  TimeStandardController.m
//  PNS Times
//
//  Created by JASON CROSS on 7/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TimeStandardController.h"
#import "TimeStandardDataAccess.h"
#import "SwimmingTimeStandardsAppDelegate.h"


@implementation TimeStandardController

@synthesize settingLabelText, settingValue;

- (void) setSettingLabelText:(NSString *) value {
	if ([[value lowercaseString] isEqualToString: @"time standard"]) {
		settingLabelText = @"Time Standard";
	}
}

#pragma mark -
#pragma mark Initialization



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	_appDelegate = (SwimmingTimeStandardsAppDelegate *)[[UIApplication sharedApplication]
												  delegate];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self setSettingLabelText: @"Time Standard"];
	
	TimeStandardDataAccess * timeStandardDataAccess = [_appDelegate timeStandardDataAccess];
	
	if (timeStandardDataAccess != nil) {
        _settingList = [timeStandardDataAccess getAllTimeStandardNames];
	}
	else {
		NSLog(@"Time Standard Data Access is nil. Cannot load view properly");
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_settingList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"GenderCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	NSUInteger row = [indexPath row];
	cell.textLabel.text = _settingList[row];
	
	// lastIndexPath is nil when the view loads for the first time.
	// see if any time standard has been saved; this will be pre-selected
	if (_lastIndexPath == nil) {
		NSString * tempStandardName = [_appDelegate getHomeScreenTimeStandard];
		NSInteger savedTimeStandard = [_settingList indexOfObject:tempStandardName];
		if (savedTimeStandard == row) {
			_lastIndexPath = indexPath;
		}
	}
		
	NSUInteger oldRow = [_lastIndexPath row];
	cell.accessoryType = (row == oldRow && _lastIndexPath != nil) ?
	UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableViewParam didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	int newRow = [indexPath row];
	int oldRow = (_lastIndexPath != nil) ? [_lastIndexPath row] : -1;
	
	if (newRow != oldRow) {
		UITableViewCell * newCell = [tableViewParam cellForRowAtIndexPath:indexPath];
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		UITableViewCell * oldCell = [tableViewParam cellForRowAtIndexPath: _lastIndexPath];
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		_lastIndexPath = indexPath;
		settingValue = _settingList[newRow];
		
		NSManagedObject * tempHomeScreenValues = [_appDelegate getHomeScreenValues];
		[tempHomeScreenValues setValue:settingValue forKey:@"homeScreenStandardName"];
		
		[_appDelegate saveContext];
		[self.navigationController popViewControllerAnimated:YES];		
	}
	
	[tableViewParam deselectRowAtIndexPath: indexPath animated: YES];
}



#pragma mark -
#pragma mark Memory management


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[super viewDidUnload];
}




@end

