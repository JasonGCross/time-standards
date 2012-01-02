//
//  TimeStandardAndSwimmerController.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TimeStandardAndSwimmerController.h"
#import "TimeStandardDataAccess.h"
#import "SwimmingTimeStandardsAppDelegate.h"
#import "SwimmerDetailViewController.h"


@interface TimeStandardAndSwimmerController(private)
- (void) setSettingLabelText:(NSString *) value;
- (void) pushDetailControllerForSwimmer: (NSManagedObject *) swimmer;
- (void) updateCell: (UITableViewCell *) cell fromSwimmer: (NSManagedObject *) swimmer;
- (NSManagedObjectContext *) managedObjectContext;
- (NSFetchedResultsController *) fetchedResultsController;
@end


@implementation TimeStandardAndSwimmerController


@synthesize timeStandardSettingLabelText;
@synthesize settingValue;

@synthesize swimmerSettingLabelText;
@synthesize nibLoadedSwimmerCell;
@synthesize nibLoadedSwimmerCellEditingView;


#pragma mark - View lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (SwimmingTimeStandardsAppDelegate *)[[UIApplication sharedApplication] 
                                                       delegate];
    self.title = @"";
    

    // time standards
    [self setSettingLabelText: @"Time Standard"];
	
	TimeStandardDataAccess * timeStandardDataAccess = [appDelegate timeStandardDataAccess];
	
	if (timeStandardDataAccess != nil) {
        [_settingList release];
        _settingList = [[timeStandardDataAccess getAllTimeStandardNames] retain];
	}
	else {
		NSLog(@"Time Standard Data Access is nil. Cannot load view properly");
	}

    
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
	
    [_defaultTintColor release];
	_defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [segmentedControl release];
    
	self.navigationItem.rightBarButtonItem = segmentBarItem;
    [segmentBarItem release];
	
	[self setSettingLabelText: @"Swimmer"];	
}


- (void)viewWillAppear:(BOOL)animated
{
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - private helper methods

- (void) setSettingLabelText:(NSString *) value {
	if ([[value lowercaseString] isEqualToString: @"time standard"]) {
		timeStandardSettingLabelText = @"Time Standard";
	}
}


- (void) pushDetailControllerForSwimmer: (NSManagedObject *) swimmer {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"HomeScreenValues"
								   inManagedObjectContext:self.managedObjectContext]];
	NSError *error = nil;
	NSArray *objects = [self.managedObjectContext executeFetchRequest: request error:&error];
	if(error) {
		NSLog(@"Error fetching request %@", [error localizedDescription]);
	}
	[request release];
	
	NSManagedObject * homeScreenValue = nil;
	if ([objects count] == 0) {
		homeScreenValue = [NSEntityDescription insertNewObjectForEntityForName:@"HomeScreenValues" 
														inManagedObjectContext:self.managedObjectContext];
	}
	else {
		homeScreenValue = [objects objectAtIndex:0];
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
	SwimmerDetailViewController *detailViewController = [[[SwimmerDetailViewController alloc] init] autorelease];
	
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSUInteger rows = sectionCount;
    return rows;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case timeStandardSection:
            return [_settingList count];
            break;
        case swimmerSection: {
            id <NSFetchedResultsSectionInfo> sectionInfo = nil;
            NSArray * sections = [[self fetchedResultsController] sections];
            // note that the fetched results controller doesn't know about any other
            // sections in this table (i.e. the time standards), so we must explicitly
            // tell the fetched results controller to only look in the first position
            sectionInfo = [sections objectAtIndex:0];
            return [sectionInfo numberOfObjects];
            break;
        }
        default:
            return 0;
            break;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    switch (section) {
        case timeStandardSection:
            return 44.0f;
            break;
        case swimmerSection:
            return 76.0f;
        default:
            return 44.0f;
            break;
    }
}

- (UIView *)tableView: (UITableView *) tableView viewForHeaderInSection:(NSInteger)section {
    CGRect headerFrame = CGRectMake(0.0f, 0.0f, 300.0f, 36.0f);
    CGRect labelFrame = CGRectMake(10.0f, 4.0f, 290.0f, 26.0f);
    UIView * headerView = [[UIView alloc] initWithFrame: headerFrame];
    [headerView setBackgroundColor:[UIColor colorWithRed:0.718 green:0.761 blue:0.851 alpha:1.000]];
    UILabel * headerLabel = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
    [headerLabel setBackgroundColor: [UIColor colorWithRed:0.718 green:0.761 blue:0.851 alpha:1.000]];
    [headerView insertSubview: headerLabel atIndex:0];
    UIFont * headerFont = [UIFont boldSystemFontOfSize:18.0f];
    headerLabel.font = headerFont;
    switch (section) {
        case timeStandardSection:
            headerLabel.text = @"Time Standards";
            break;
        case swimmerSection:
            headerLabel.text = @"Swimmers";
            break;
        default:
            break;
    }
    return [headerView autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * timeStandardCellIdentifier = @"TimeStandardCell";
    static NSString *CellIdentifier = @"SwimmerListViewCell";
	static NSString *EditingCellIdentifier = @"SwimmerListViewCellEditing";
    
    static NSManagedObject * homeScreenValues = nil;
    if (homeScreenValues == nil) {
        [appDelegate getHomeScreenValues];
    }
    
    UITableViewCell *cell = nil;
    NSUInteger section = [indexPath section];
    
    switch (section) {
        case timeStandardSection: {
            cell = [tableView dequeueReusableCellWithIdentifier:timeStandardCellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                               reuseIdentifier:timeStandardCellIdentifier] autorelease];
            }
            
            // Configure the cell...
            NSUInteger row = [indexPath row];
            cell.textLabel.text = [_settingList objectAtIndex:row];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            
            // lastIndexPath is nil when the view loads for the first time.
            // see if any time standard has been saved; this will be pre-selected
            if (_lastIndexPath == nil) {
                NSString * tempStandardName = [appDelegate getHomeScreenTimeStandard];
                NSInteger savedTimeStandard = [_settingList indexOfObject:tempStandardName];
                if (savedTimeStandard == row) {
                    [indexPath retain];
                    [_lastIndexPath release];
                    _lastIndexPath = indexPath;
                }
            }
            
            NSUInteger oldRow = [_lastIndexPath row];
            cell.accessoryType = (row == oldRow && _lastIndexPath != nil) ? 
                UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
        }
        case swimmerSection: {
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
            // the fetched results controller is not expecting there to be two sections, so we must create
            // an indexPath which the fetched results controller can understand
            NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:indexPath.row 
                                                            inSection:0];
            NSManagedObject * thisCellSwimmer = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
            
            [self updateCell: cell fromSwimmer: thisCellSwimmer];		
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            // show this cell as highlighted if it matches the current swimmer
            NSManagedObject * currentSwimmer = [homeScreenValues valueForKey:@"homeScreenSwimmer"];
            cell.highlighted = (currentSwimmer == thisCellSwimmer) ? YES : NO;
            break;
        }
        default:
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:CellIdentifier] autorelease];
            break;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    NSUInteger section = [indexPath section];
    
    switch (section) {
        case timeStandardSection:
            return NO;
            break;
        case swimmerSection:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    
    switch (section) {
        case timeStandardSection:
            // we should never be here, but to be save include the case and take no action
            break;
        case swimmerSection: {
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
                        NSManagedObject * newSwimmer = (NSManagedObject *)[swimmers objectAtIndex:0];
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

            break;
        }
        default:
            break;
    }

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableViewParam didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    switch (section) {
        case timeStandardSection: {
            int newRow = [indexPath row];
            int oldRow = (_lastIndexPath != nil) ? [_lastIndexPath row] : -1;
            
            if (newRow != oldRow) {
                UITableViewCell * newCell = [tableViewParam cellForRowAtIndexPath:indexPath];
                newCell.accessoryType = UITableViewCellAccessoryCheckmark;
                UITableViewCell * oldCell = [tableViewParam cellForRowAtIndexPath: _lastIndexPath];
                oldCell.accessoryType = UITableViewCellAccessoryNone;
                [indexPath retain];
                [_lastIndexPath release];
                _lastIndexPath = indexPath;
                settingValue = [_settingList objectAtIndex:newRow];
                
                NSManagedObject * tempHomeScreenValues = [appDelegate getHomeScreenValues];
                [tempHomeScreenValues setValue:settingValue forKey:@"homeScreenStandardName"];
                
                [appDelegate saveContext];
                NSNotification * notification = [NSNotification notificationWithName:STSHomeScreenValuesChangedKey
                                                                              object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];		
            }
            
            [tableViewParam deselectRowAtIndexPath: indexPath animated: YES];

            break;
        }
        case swimmerSection: {
            [tableViewParam deselectRowAtIndexPath:indexPath animated:YES];
            
            // the fetched results controller is not expecting there to be two sections, so we must create
            // an indexPath which the fetched results controller can understand
            NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:indexPath.row 
                                                            inSection:0];
            NSManagedObject * currentSwimmer = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
            
            NSManagedObject * homeScreenValues = [appDelegate getHomeScreenValues];
            [homeScreenValues setValue:currentSwimmer forKey:@"homeScreenSwimmer"];
            
            [appDelegate saveContext];
            NSNotification * notification = [NSNotification notificationWithName:STSHomeScreenValuesChangedKey
                                                                          object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];	
            break;
        }
        default:
            break;
    }
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
	fetchedResultsController_ = nil;
	managedObjectContext_ = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    nibLoadedSwimmerCell = nil;
    nibLoadedSwimmerCellEditingView = nil;
}


- (void)dealloc {
    [timeStandardSettingLabelText release];
	[settingValue release];
	[_settingList release];
	[_lastIndexPath release];
    
	[swimmerSettingLabelText release];
	[_defaultTintColor release];
    [nibLoadedSwimmerCell release];
    [nibLoadedSwimmerCellEditingView release];
    
    [super dealloc];
}


@end
