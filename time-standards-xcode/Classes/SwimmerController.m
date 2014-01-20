//
//  SwimmerController.m
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SwimmerController.h"
#import "SwimmingTimeStandardsAppDelegate.h"
#import "SwimmerDetailViewController.h"

@implementation SwimmerController

@synthesize settingLabelText;
@synthesize nibLoadedSwimmerCell;
@synthesize nibLoadedSwimmerCellEditingView;


#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform 
    // customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self)  {
        appDelegate = (SwimmingTimeStandardsAppDelegate *)[[UIApplication sharedApplication] 
                                                           delegate];
    }
    return self;
}

#pragma mark -
#pragma mark private helper methods

- (void) pushDetailControllerForSwimmer: (NSManagedObject *) swimmer {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"HomeScreenValues"
								   inManagedObjectContext:self.managedObjectContext]];
	NSError *error = nil;
	NSArray *objects = [self.managedObjectContext executeFetchRequest: request error:&error];
	if(error) {
		NSLog(@"Error fetching request %@", [error localizedDescription]);
	}
	
	NSManagedObject * homeScreenValue = nil;
	if ([objects count] == 0) {
		homeScreenValue = [NSEntityDescription insertNewObjectForEntityForName:@"HomeScreenValues" 
														inManagedObjectContext:self.managedObjectContext];
	}
	else {
		homeScreenValue = objects[0];
	}
	if(homeScreenValue != nil) {
		[homeScreenValue setValue:swimmer forKey:@"homeScreenSwimmer"];
        
        // the detail controller must know the "current swimmer" so it displays
        // the correct swimmer. the app delegate will take care of this for all views.
        [homeScreenValue setValue:swimmer forKey:@"currentSwimmer"];
	}
    // save Core Data before pushing detailViewController, in case there is a memory warning
    // and objects are released
    [appDelegate saveContext];
	
	// Navigation logic may go here. Create and push another view controller.
	SwimmerDetailViewController *detailViewController = [[SwimmerDetailViewController alloc] init];
	
    // Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController animated:YES];
    return;
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
		UIImage * image;
		if (photo != nil) {
			image = [photo valueForKey:@"photoImage"];
			if (image != nil) {
				photoImageView.image = image;
			}
		}
		else {
			image = [UIImage imageNamed:STSImageThumnailName];
			photoImageView.image = image;
		}

	}
}

- (NSManagedObjectContext *) managedObjectContext {
	if(managedObjectContext_ != nil) {
		return managedObjectContext_;
	}
	managedObjectContext_ = [appDelegate managedObjectContext];
	return managedObjectContext_;
}

- (NSFetchedResultsController *) fetchedResultsController{
	if (fetchedResultsController_ != nil) {
		return fetchedResultsController_;
	}
	fetchedResultsController_ = [appDelegate fetchedResultsController];
	[fetchedResultsController_ setDelegate:self];
	return fetchedResultsController_;
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
		
	self.tableView.rowHeight = 76;
	
	// "Segmented" control to the right
	NSArray *segmentTextContent = @[NSLocalizedString(@"Edit", @""),
								   NSLocalizedString(@"+", @"")];
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
	
	_defaultTintColor = segmentedControl.tintColor;	// keep track of this for later
	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    
	self.navigationItem.rightBarButtonItem = segmentBarItem;
	
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
		segmentedControl.tintColor = _defaultTintColor;
	}
	
	if (self.editing) {
		[self handleEditTapped];
	}
	else {
		 [self.tableView reloadData];
	}
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[[self fetchedResultsController] sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = nil;
	sectionInfo = [[self fetchedResultsController] sections][section];
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
		[self.managedObjectContext deleteObject:swimmer];
				
		// update the HomeScreenValues if needed
		NSManagedObject * homeScreenValues = [appDelegate getHomeScreenValues];
		NSManagedObject * homeScreenSwimmer = [homeScreenValues valueForKey:@"homeScreenSwimmer"];
		if (homeScreenSwimmer == nil) {
			// try to replace the missing swimmer with another
			NSArray * swimmers = [self.fetchedResultsController fetchedObjects];
			if ([swimmers count] > 0) {
				NSManagedObject * newSwimmer = (NSManagedObject *)swimmers[0];
				[homeScreenValues setValue:newSwimmer forKey:@"homeScreenSwimmer"];
			}
		}
		
		// Save the Context
		[appDelegate saveContext];
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

- (void)tableView:(UITableView *)tableViewParam didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableViewParam deselectRowAtIndexPath:indexPath animated:YES];
    NSManagedObject * currentSwimmer = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	NSManagedObject * homeScreenValues = [appDelegate getHomeScreenValues];
	[homeScreenValues setValue:currentSwimmer forKey:@"homeScreenSwimmer"];
	
	[appDelegate saveContext];
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
                                                              inManagedObjectContext:self.managedObjectContext];
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
			array = @[newIndexPath];
			[[self tableView] insertRowsAtIndexPaths:array 
									withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			array = @[indexPath];
			[[self tableView] deleteRowsAtIndexPaths:array
									withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeMove:
			array = @[newIndexPath];
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
	fetchedResultsController_ = nil;
	managedObjectContext_ = nil;
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	nibLoadedSwimmerCell = nil;
    nibLoadedSwimmerCellEditingView = nil;
}




@end

