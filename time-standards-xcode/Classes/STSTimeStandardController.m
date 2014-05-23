//
//  TimeStandardController.m
//  PNS Times
//
//  Created by JASON CROSS on 7/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "STSTimeStandardController.h"
#import "STSSwimmerDataAccess.h"
#import "STSTimeStandardDataAccess.h"
#import "STSTimeStandardHomeScreenTableCell.h"



@interface STSTimeStandardController ()
@property (strong,nonatomic) NSMutableArray 	* settingList;
@property (strong,nonatomic) NSIndexPath		* lastIndexPath;
@end



@implementation STSTimeStandardController

- (void) setSettingLabelText:(NSString *) value {
	if ([[value lowercaseString] isEqualToString: @"time standard"]) {
		_settingLabelText = @"Time Standard";
	}
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self setTitle: @"Time Standard"];
	
	STSTimeStandardDataAccess * timeStandardDataAccess = [STSTimeStandardDataAccess sharedDataAccess];
	
	if (timeStandardDataAccess != nil) {
		self.settingList = [NSMutableArray arrayWithArray:[timeStandardDataAccess getAllTimeStandardNames]];
	}
	else {
		NSLog(@"Time Standard Data Access is nil. Cannot load view properly");
	}
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_settingList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView registerNib:[STSTimeStandardHomeScreenTableCell nib]
    forCellReuseIdentifier:[STSTimeStandardHomeScreenTableCell cellIdentifier]];
    UITableViewCell *cell = [STSTimeStandardHomeScreenTableCell cellForTableView:tableView];

    // Configure the cell...
	NSUInteger row = [indexPath row];
	cell.textLabel.text = (self.settingList)[row];
	
	// lastIndexPath is nil when the view loads for the first time.
	// see if any time standard has been saved; this will be pre-selected
	if (_lastIndexPath == nil) {
		NSString * tempStandardName = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenTimeStandard];
		NSInteger savedTimeStandard = [_settingList indexOfObject:tempStandardName];
		if (savedTimeStandard == row) {
			self.lastIndexPath = indexPath;
		}
	}
		
	NSUInteger oldRow = [_lastIndexPath row];
	cell.accessoryType = (row == oldRow && _lastIndexPath != nil) ?
	UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSInteger newRow = [indexPath row];
	NSInteger oldRow = (_lastIndexPath != nil) ? [_lastIndexPath row] : -1;
	
	if (newRow != oldRow) {
		UITableViewCell * newCell = [tableView cellForRowAtIndexPath:indexPath];
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		UITableViewCell * oldCell = [tableView cellForRowAtIndexPath: _lastIndexPath];
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		self.lastIndexPath = indexPath;
		self.settingValue = _settingList[newRow];
		
		NSManagedObject * tempHomeScreenValues = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenValues];
		[tempHomeScreenValues setValue:_settingValue forKey:@"homeScreenStandardName"];
		
		[[STSSwimmerDataAccess sharedDataAccess] saveContext];
		[self.navigationController popViewControllerAnimated:YES];		
	}
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}




@end

