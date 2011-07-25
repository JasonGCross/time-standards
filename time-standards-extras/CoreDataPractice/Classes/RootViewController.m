    //
//  RootViewController.m
//  CoreDataPractice
//
//  Created by JASON CROSS on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "CoreDataPracticeAppDelegate.h"
#import "SwimmerController.h"


@implementation RootViewController

@synthesize nibLoadedStandardCell, nibLoadedSwimmerCell, tableView;
@synthesize controllers;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Time Standards";
	
	appDelegate = (CoreDataPracticeAppDelegate *)[[UIApplication sharedApplication]
												  delegate];
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	// swimmer
	swimmerController = [[SwimmerController alloc] initWithStyle:UITableViewStyleGrouped];
	swimmerController.managedObjectContext = [appDelegate managedObjectContext];
	swimmerController.settingLabelText = @"Swimmer";
	swimmerController.title = @"Swimmer";
	[array addObject: swimmerController];
	
	self.controllers = array;
	[array release];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.tableView reloadData];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableViewParam cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SwimmerCellIdentifier = @"SwimmerCell";
	UITableViewCell *cell = nil;
	
	cell = [tableViewParam dequeueReusableCellWithIdentifier:SwimmerCellIdentifier];
	if (cell == nil) {
		
		[[NSBundle mainBundle] loadNibNamed:@"SwimmerTableCell" 
									  owner:self 
									options:nil];
		cell = nibLoadedSwimmerCell;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Configure the cell.
	NSManagedObject * swimmer = [appDelegate getHomeScreenObject:@"homeScreenSwimmer"
												   forEntityName:@"Swimmer"
												withDefaultValue:@"name this swimmer" 
												   forDefaultKey:@"swimmerName"];
	
	UILabel * swimmerNameLabel = (UILabel *) [cell viewWithTag:1];
	swimmerNameLabel.text = [swimmer valueForKey:@"swimmerName"];
	
	UILabel * swimmerDescriptionLabel = (UILabel *) [cell viewWithTag:2];
	NSMutableString * swimmerDescription = [NSMutableString stringWithCapacity:20];
	NSString * swimmerAgeGroup = [swimmer valueForKey:@"swimmerAgeGroup"];
	swimmerAgeGroup = (swimmerAgeGroup == nil) ? @"(re)select age group" : swimmerAgeGroup;
	[swimmerDescription appendString:swimmerAgeGroup];
	[swimmerDescription appendString:@" "];
	
	NSString * swimmerGender = [swimmer valueForKey:@"swimmerGender"];
	swimmerGender = (swimmerGender == nil) ? @"select gender" : swimmerGender;
	[swimmerDescription appendString:swimmerGender];
	swimmerDescriptionLabel.text = swimmerDescription;
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
	UITableViewController *detailViewController = [self.controllers 
												   objectAtIndex:row];
	// ...
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController 
										 animated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	swimmerController = nil;
}


- (void)dealloc {
	[swimmerController release];
    [super dealloc];
}

#pragma mark -
#pragma mark Picker Data Source Methods

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 3;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView 
 numberOfRowsInComponent:(NSInteger)component {
	return 1;
	
}

#pragma mark Picker Delegate Methods

- (NSString *) pickerView:(UIPickerView *)pickerView 
			  titleForRow:(NSInteger)row 
			 forComponent:(NSInteger)component {
	switch (component) {
		case 0:
			return @"50";
			break;
		case 1:
			return @"free";
			break;
		case 2:
			return @"SCY";
			break;
		default:
			return @"";
			break;
	}
}


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row 
		inComponent:(NSInteger)component {
}




@end
