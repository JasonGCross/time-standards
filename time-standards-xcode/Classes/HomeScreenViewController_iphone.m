//
//  HomeScreenViewController_iphone.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeScreenViewController_iphone.h"
#import "TimeStandardController.h"
#import "SwimmerController.h"
#import "STSAppDelegate_iphone.h"

@implementation HomeScreenViewController_iphone

@synthesize controllers;
@synthesize tableView;

#pragma mark - view lifecycle

- (id) init {
    return [self initWithNibName:@"HomeScreenViewController_iphone" bundle:nil];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        // time standards
        timeStandardController = [[TimeStandardController alloc] initWithStyle:UITableViewStyleGrouped];
        timeStandardController.settingLabelText = @"Time Standard";
        timeStandardController.title = @"Time Standard";
        [array addObject: timeStandardController];
        
        // swimmer
        swimmerController = [[SwimmerController alloc] initWithStyle:UITableViewStyleGrouped];
        swimmerController.settingLabelText = @"Swimmer";
        swimmerController.title = @"Swimmer";
        [array addObject: swimmerController];
        
        self.controllers = array;
        [array release];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[tableView reloadData];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.controllers count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableViewParam cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *StandardCellIdentifier = @"StandardCell";
	static NSString *SwimmerCellIdentifier = @"SwimmerCell";
	NSUInteger row = [indexPath row];
	UITableViewCell *cell = nil;
	
	switch (row) {
		case STSStandardRow:
			cell = [tableViewParam dequeueReusableCellWithIdentifier:StandardCellIdentifier];
			if (cell == nil) {
				[[NSBundle mainBundle] loadNibNamed:@"StandardTableCell" 
											  owner:self 
											options:nil];
				cell = nibLoadedStandardCell;
			}
			// Configure the cell.
			NSString * timeStandardName = [appDelegate getHomeScreenTimeStandard];
			UILabel * standardNameLabel = (UILabel *) [cell viewWithTag:1];
			standardNameLabel.text = timeStandardName;
			self.previousTimeStandard = timeStandardName;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case STSSwimmerRow:
			cell = [tableViewParam dequeueReusableCellWithIdentifier:SwimmerCellIdentifier];
			if (cell == nil) {
				
				[[NSBundle mainBundle] loadNibNamed:@"SwimmerTableCell" 
											  owner:self 
											options:nil];
				cell = nibLoadedSwimmerCell;
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			// Configure the cell.
			NSManagedObject * swimmer = [appDelegate getHomeScreenSwimmer];
			
			UILabel * swimmerNameLabel = (UILabel *) [cell viewWithTag:1];
			swimmerNameLabel.text = [swimmer valueForKey:@"swimmerName"];
			
			UILabel * swimmerDescriptionLabel = (UILabel *) [cell viewWithTag:2];
			NSMutableString * swimmerDescription = [NSMutableString stringWithCapacity:20];
			NSString * swimmerAgeGroup = [swimmer valueForKey:@"swimmerAgeGroup"];
			self.previousAgeGroup = swimmerAgeGroup;
			swimmerAgeGroup = (swimmerAgeGroup == nil) ? @"(re)select age group" : swimmerAgeGroup;
			[swimmerDescription appendString:swimmerAgeGroup];
			[swimmerDescription appendString:@" "];
			
			NSString * swimmerGender = [swimmer valueForKey:@"swimmerGender"];
			self.previousGender = swimmerGender;
			swimmerGender = (swimmerGender == nil) ? @"select gender" : swimmerGender;
			[swimmerDescription appendString:swimmerGender];
			swimmerDescriptionLabel.text = swimmerDescription;
			
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
			break;
		default:
			break;
	}
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableViewParam didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    UITableViewController *detailViewController = [self.controllers 
                                                   objectAtIndex:row];
	
	// ...
	// Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController 
                                         animated:YES];
    [tableViewParam deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Memory management

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.tableView = nil;
}

- (void)dealloc {
	[controllers release];
    [tableView release];
    [timeStandardController release];
	[swimmerController release];
    
    [super dealloc];
}

@end



