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

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (SwimmingTimeStandardsAppDelegate *)[[UIApplication sharedApplication]
												  delegate];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self setSettingLabelText: @"Time Standard"];
	
	TimeStandardDataAccess * timeStandardDataAccess = [appDelegate timeStandardDataAccess];
	
	if (timeStandardDataAccess != nil) {
		settingList = [[timeStandardDataAccess getAllTimeStandardNames] retain];
	}
	else {
		NSLog(@"Time Standard Data Access is nil. Cannot load view properly");
	}
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [settingList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"GenderCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [settingList objectAtIndex:row];
	
	// lastIndexPath is nil when the view loads for the first time.
	// see if any time standard has been saved; this will be pre-selected
	if (lastIndexPath == nil) {
		NSString * tempStandardName = [appDelegate getHomeScreenTimeStandard];
		NSInteger savedTimeStandard = [settingList indexOfObject:tempStandardName];
		if (savedTimeStandard == row) {
			lastIndexPath = indexPath;
		}
	}
		
	NSUInteger oldRow = [lastIndexPath row];
	cell.accessoryType = (row == oldRow && lastIndexPath != nil) ?
	UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	int newRow = [indexPath row];
	int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
	
	if (newRow != oldRow) {
		UITableViewCell * newCell = [tableView cellForRowAtIndexPath:indexPath];
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		UITableViewCell * oldCell = [tableView cellForRowAtIndexPath: lastIndexPath];
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		lastIndexPath = indexPath;
		settingValue = [settingList objectAtIndex:newRow];
		
		NSManagedObject * tempHomeScreenValues = [appDelegate getHomeScreenValues];
		[tempHomeScreenValues setValue:settingValue forKey:@"homeScreenStandardName"];
		
		[appDelegate saveContext];
		[self.navigationController popViewControllerAnimated:YES];		
	}
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}



#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}
 */

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	settingLabelText = nil;
	settingValue = nil;
	settingList = nil;
	lastIndexPath = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[settingLabelText release];
	[settingValue release];
	[settingList release];
	[lastIndexPath release];	
    [super dealloc];
}


@end

