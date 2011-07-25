//
//  SwimmerController.m
//  CoreDataPractice
//
//  Created by JASON CROSS on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SwimmerController.h"
#import "SwimmingTimesStandardsGlobals.h"
#import "CoreDataPracticeAppDelegate.h"
#import "SwimmerDetailViewController.h"

@implementation SwimmerController

@synthesize settingLabelText;
@synthesize nibLoadedSwimmerCell;
@synthesize nibLoadedSwimmerCellEditingView;
@synthesize managedObjectContext;
@synthesize fetchedResultsController;


- (void) pushDetailControllerForSwimmer: (NSManagedObject *) swimmer {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"HomeScreenValues"
								   inManagedObjectContext:managedObjectContext]];
	NSError *error = nil;
	NSArray *objects = [managedObjectContext executeFetchRequest: request error:&error];
	if(error) {
		NSLog(@"Error fetching request %@", [error localizedDescription]);
	}
	[request release];
	
	NSManagedObject * homeScreenValue = nil;
	if ([objects count] == 0) {
		homeScreenValue = [NSEntityDescription insertNewObjectForEntityForName:@"HomeScreenValues" 
														inManagedObjectContext:managedObjectContext];
	}
	else {
		homeScreenValue = [objects objectAtIndex:0];
	}
	if(homeScreenValue != nil) {
		[homeScreenValue setValue:swimmer forKey:@"homeScreenSwimmer"];
	}
	
	// Navigation logic may go here. Create and push another view controller.
	SwimmerDetailViewController *detailViewController = [[SwimmerDetailViewController alloc] 
														 initWithNibName:@"SwimmerDetailView"
														 bundle:nil];
	[detailViewController setSwimmer:swimmer];
	
    // Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController animated:YES];
	if([managedObjectContext save:&error]) {
		return;
	}
	NSLog(@"save error %@, %@", error, [error userInfo]);
	exit(-1); // Fail
}

- (void) updateCell: (UITableViewCell *) cell fromSwimmer: (NSManagedObject *) swimmer  {
	UILabel * swimmerNameLabel = (UILabel *) [cell viewWithTag:1];
	swimmerNameLabel.text = [swimmer valueForKey:@"swimmerName"];
	
	UILabel * swimmerGenderLabel = (UILabel *) [cell viewWithTag:2];
	NSString * swimmerGender = [swimmer valueForKey:@"swimmerGender"];
	swimmerGenderLabel.text = (swimmerGender == nil) ? @"select gender" : swimmerGender;
	
	UILabel * swimmerAgeGroupLabel = (UILabel *) [cell viewWithTag:3];
	NSString * swimmerAgeGroup = [swimmer valueForKey:@"swimmerAgeGroup"];
	swimmerAgeGroupLabel.text = (swimmerAgeGroup == nil) ? @"select age group" : swimmerAgeGroup;
	
	UIImageView * photoImageView = (UIImageView *) [cell viewWithTag:4];
	if(swimmer != nil) {
		NSManagedObject * photo = [swimmer valueForKey:@"swimmerPhoto"];
		if (photo != nil) {
			UIImage * image = [photo valueForKey:@"photoImage"];
			if (image != nil) {
				photoImageView.image = image;
				[photoImageView sizeToFit];
			}
		}
	}
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (CoreDataPracticeAppDelegate *)[[UIApplication sharedApplication]
												  delegate];
	fetchedResultsController = [appDelegate fetchedResultsController];
	[fetchedResultsController setDelegate:self];
	
	// the managedObjectContext should already be set by the class which instantiated this ViewController
	if (managedObjectContext == nil) {
		managedObjectContext = [appDelegate managedObjectContext];
	}
	
	self.tableView.rowHeight = 76;
	
	// "Segmented" control to the right
	NSArray *segmentTextContent = [NSArray arrayWithObjects:
								   NSLocalizedString(@"Edit", @""),
								   NSLocalizedString(@"+", @""),
								   nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	//segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 90, STSCustomButtonHeight);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
	
	[segmentedControl addTarget:self
						 action:@selector(handleSegmentedControllerChanged:)
			   forControlEvents:UIControlEventValueChanged];
	
	defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [segmentedControl release];
    
	self.navigationItem.rightBarButtonItem = segmentBarItem;
    [segmentBarItem release];
	
	[self setSettingLabelText: @"Swimmer"];	
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// Before we show this view make sure the segmentedControl matches the nav bar style
	if (self.navigationController.navigationBar.barStyle == UIBarStyleBlackTranslucent ||
		self.navigationController.navigationBar.barStyle == UIBarStyleBlackOpaque)
	{
		segmentedControl.tintColor = [UIColor darkGrayColor];
	}
	
	else {
		segmentedControl.tintColor = defaultTintColor;
	}
	
	if (self.editing) {
		[self handleEditTapped];
	}
	else {
		 [self.tableView reloadData];
	}
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
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
    // Return the number of sections.
    return [[[self fetchedResultsController] sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = nil;
	sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SwimmerListViewCell";
	static NSString *EditingCellIdentifier = @"SwimmerListViewCellEditing";
	
	UITableViewCell *cell = nil;
	
	if (tableView.editing == NO) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"SwimmersListTableCell" 
										  owner:self 
										options:nil];
			cell = nibLoadedSwimmerCell;
		}		
	}
	else {
		cell = [tableView dequeueReusableCellWithIdentifier:EditingCellIdentifier];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"SwimmersListTableCellEditView"
										  owner:self
										options:nil];
			cell = nibLoadedSwimmerCellEditingView;
		}
	}
	
    // Configure the cell...
	NSManagedObject * currentSwimmer = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	[self updateCell: cell fromSwimmer: currentSwimmer];		
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void) tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the object from Core Data
		NSManagedObject * swimmer = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[managedObjectContext deleteObject:swimmer];
		
		// update the HomeScreenValues if needed
		NSManagedObject * homeScreenValues = [appDelegate getHomeScreenValues];
		NSManagedObject * homeScreenSwimmer = [homeScreenValues valueForKey:@"homeScreenSwimmer"];
		if (homeScreenSwimmer == nil) {
			// try to replace the missing swimmer with another
			NSArray * swimmers = [fetchedResultsController fetchedObjects];
			if ([swimmers count] > 0) {
				NSManagedObject * newSwimmer = (NSManagedObject *)[swimmers objectAtIndex:0];
				[homeScreenValues setValue:newSwimmer forKey:@"homeScreenSwimmer"];
			}
		}
		
		// Save the Context
		NSError * error = nil;
		[managedObjectContext save:&error];
		if (error) {
			NSLog(@"Error saving managed object context: %@", [error localizedDescription]);
		}
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		[self handleAddTapped];
	}   
}



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
    NSManagedObject * currentSwimmer = [fetchedResultsController objectAtIndexPath:indexPath];
	
	NSManagedObject * homeScreenValues = [appDelegate getHomeScreenValues];
	[homeScreenValues setValue:currentSwimmer forKey:@"homeScreenSwimmer"];
	
	NSError *error = nil;
	NSManagedObjectContext * moc = [appDelegate managedObjectContext];
	[moc save:&error];
	if (error) {
		NSLog(@"Error saving managed object context: %@", [error localizedDescription]);
	}
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark table editing

- (IBAction) handleSegmentedControllerChanged: (id) sender {
	NSInteger selectedSegment = [segmentedControl selectedSegmentIndex];
	if (selectedSegment == 0) {
		[self handleEditTapped];
	}
	else {
		[self handleAddTapped];
	}
	
}

- (IBAction) handleEditTapped {
	if (self.editing) {
		[self setEditing:NO animated:YES];
		[segmentedControl setTitle:@"Edit" forSegmentAtIndex:0];
	}
	else {
		[self setEditing:YES animated:YES];
		[segmentedControl setTitle:@"Done" forSegmentAtIndex:0];
	}
	[self.tableView reloadData];
}

- (IBAction) handleAddTapped {
	NSManagedObject * swimmer = [NSEntityDescription insertNewObjectForEntityForName:@"Swimmer" 
															  inManagedObjectContext:managedObjectContext];
	[swimmer setValue:@"name this swimmer" forKey:@"swimmerName"];
	
	// immediately begin editing the newly created swimmer
	[self pushDetailControllerForSwimmer:swimmer];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	NSManagedObject * swimmer = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	[self pushDetailControllerForSwimmer:swimmer];
}



#pragma mark -
#pragma mark FetchController delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller 
{
	[[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller 
   didChangeObject:(id)anObject 
       atIndexPath:(NSIndexPath*)indexPath 
     forChangeType:(NSFetchedResultsChangeType)type 
      newIndexPath:(NSIndexPath*)newIndexPath 
{
	NSArray *array = nil;
	NSIndexSet *section = [NSIndexSet indexSetWithIndex:[newIndexPath section]];
	
	switch (type) {
		case NSFetchedResultsChangeInsert:
			array = [NSArray arrayWithObject:newIndexPath];
			[[self tableView] insertRowsAtIndexPaths:array 
									withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			array = [NSArray arrayWithObject:indexPath];
			[[self tableView] deleteRowsAtIndexPaths:array
									withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeMove:
			array = [NSArray arrayWithObject:newIndexPath];
			[[self tableView] deleteRowsAtIndexPaths:array
									withRowAnimation:UITableViewRowAnimationFade];
			[[self tableView] reloadSections:section
							withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
			[self updateCell:[[self tableView] cellForRowAtIndexPath:indexPath]
				 fromSwimmer:[[self fetchedResultsController] objectAtIndexPath:indexPath]];
			break;
	}
}

- (void)controller:(NSFetchedResultsController*)controller 
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo 
           atIndex:(NSUInteger)sectionIndex 
     forChangeType:(NSFetchedResultsChangeType)type 
{
	NSIndexSet *sections = [NSIndexSet indexSetWithIndex:sectionIndex];
	
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[[self tableView] insertSections:sections 
							withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[[self tableView] deleteSections:sections 
							withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller 
{
	[[self tableView] endUpdates];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	settingLabelText = nil;
}


- (void)dealloc {
	[settingLabelText release];
	[defaultTintColor release];
    [super dealloc];
}


@end

