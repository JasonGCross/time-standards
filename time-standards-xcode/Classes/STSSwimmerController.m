//
//  SwimmerController.m
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

 #import "STSSwimmerController.h"
#import "STSSwimmerDataAccess.h"
#import "STSSwimmerDetailViewController.h"
#import "STSSwimmerListTableViewCell.h"
#import "STSSwimmerListEditTableViewCell.h"
#import "STSSwimmerListTableViewCell+Binding.h"


static NSString * const kSwimmerListToSwimmerDetailSegueue = @"SwimmerListToSwimmerDetailSegueue";



@interface STSSwimmerController()
@property (nonatomic, strong) UIColor			   * defaultTintColor;
@property (nonatomic, strong) UISegmentedControl * segmentedControl;
@property (weak, nonatomic, readwrite) NSManagedObjectContext * managedObjectContext;
@property (weak, nonatomic, readwrite) NSFetchedResultsController * fetchedResultsController;
@end



@implementation STSSwimmerController

#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self setTitle: @"Swimmer"];
	
	self.tableView.rowHeight = 76;
	
	// "Segmented" control to the right
	NSArray *segmentTextContent = @[NSLocalizedString(@"Edit", @""),
                                    NSLocalizedString(@"+", @"")];
	self.segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	//segmentedControl.selectedSegmentIndex = 0;
	_segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_segmentedControl.frame = CGRectMake(0, 0, 90, STSCustomButtonHeight);
	_segmentedControl.momentary = YES;
	
	[_segmentedControl addTarget:self
                          action:@selector(handleSegmentedControllerChanged:)
                forControlEvents:UIControlEventValueChanged];
	
	self.defaultTintColor = _segmentedControl.tintColor;	// keep track of this for later
	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:_segmentedControl];
    
	self.navigationItem.rightBarButtonItem = segmentBarItem;
	
	[self setSettingLabelText: @"Swimmer"];	
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// Before we show this view make sure the segmentedControl matches the nav bar style
	if (self.navigationController.navigationBar.barStyle == UIBarStyleBlackTranslucent ||
		self.navigationController.navigationBar.barStyle == UIBarStyleBlackOpaque)
	{
		_segmentedControl.tintColor = [UIColor darkGrayColor];
	}
	
	else {
		_segmentedControl.tintColor = _defaultTintColor;
	}
	
	if (self.editing) {
		[self handleEditTapped];
	}
	else {
        [self.tableView reloadData];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark - private helper methods

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
    [[STSSwimmerDataAccess sharedDataAccess] saveContext];
	
	// Navigation logic may go here. Create and push another view controller.
    [self performSegueWithIdentifier:kSwimmerListToSwimmerDetailSegueue sender:self];

    return;
}

- (NSManagedObjectContext *) managedObjectContext {
	if(_managedObjectContext != nil) {
		return _managedObjectContext;
	}
	_managedObjectContext = [[STSSwimmerDataAccess sharedDataAccess] managedObjectContext];
	return _managedObjectContext;
}

- (NSFetchedResultsController *) fetchedResultsController{
	if (_fetchedResultsController != nil) {
		return _fetchedResultsController;
	}
	_fetchedResultsController = [[STSSwimmerDataAccess sharedDataAccess] fetchedResultsController];
	[_fetchedResultsController setDelegate:self];
	return _fetchedResultsController;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

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
    
    [tableView registerNib:[STSSwimmerListTableViewCell nib]
    forCellReuseIdentifier:[STSSwimmerListTableViewCell cellIdentifier]];
    [tableView registerNib:[STSSwimmerListEditTableViewCell nib]
    forCellReuseIdentifier:[STSSwimmerListEditTableViewCell cellIdentifier]];
    
	UITableViewCell *cell = nil;
    NSManagedObject * currentSwimmer = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	if (tableView.editing == NO) {
		cell = [STSSwimmerListTableViewCell cellForTableView:tableView];
	}
	else {
		cell = [STSSwimmerListEditTableViewCell cellForTableView:tableView];
	}
    
    [(STSSwimmerListTableViewCell*)cell bindToSwimmer:currentSwimmer];
	
    return cell;
}

// Override to support editing the table view.
- (void) tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the object from Core Data
		NSManagedObject * swimmer = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[self.managedObjectContext deleteObject:swimmer];
				
		// update the HomeScreenValues if needed
		NSManagedObject * homeScreenValues = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenValues];
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
		[[STSSwimmerDataAccess sharedDataAccess] saveContext];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		[self handleAddTapped];
	}   
}


#pragma mark -  Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject * currentSwimmer = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	NSManagedObject * homeScreenValues = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenValues];
	[homeScreenValues setValue:currentSwimmer forKey:@"homeScreenSwimmer"];
	
	[[STSSwimmerDataAccess sharedDataAccess] saveContext];
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - table editing

- (IBAction) handleSegmentedControllerChanged: (id) sender {
	NSInteger selectedSegment = [_segmentedControl selectedSegmentIndex];
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
		[_segmentedControl setTitle:@"Edit" forSegmentAtIndex:0];
	}
	else {
		[self setEditing:YES animated:YES];
		[_segmentedControl setTitle:@"Done" forSegmentAtIndex:0];
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



#pragma mark -  FetchController delegate

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
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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


#pragma mark - Segues.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueId = [segue identifier];
    
    if([segueId isEqualToString:kSwimmerListToSwimmerDetailSegueue]){
        
    }
}


@end

