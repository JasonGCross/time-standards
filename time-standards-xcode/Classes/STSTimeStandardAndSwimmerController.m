//
//  STSTimeStandardAndSwimmerController.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/19/14.
//
//

#import "STSTimeStandardAndSwimmerController.h"
#import "STSTimeStandardDataAccess.h"
#import "STSSwimmerDataAccess.h"
#import "STSSwimmerDetailViewController~ipad.h"
#import "STSSwimmerListEditTableViewCell.h"
#import "STSSwimmerListTableViewCell+Binding.h"
#import "STSTimeStandardDataAccess.h"
#import "STSTimeStandardHomeScreenTableCell.h"




@interface STSTimeStandardAndSwimmerController()
// time standards
@property (nonatomic, strong) NSString * timeStandardSettingLabelText;
@property (nonatomic, strong) NSString * settingValue;
@property (nonatomic, strong) NSArray * settingList;
@property (nonatomic, strong) NSIndexPath * lastIndexPath;

// swimmer controller
@property (nonatomic, strong) NSString * swimmerSettingLabelText;
@property (weak, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (weak, nonatomic) NSFetchedResultsController * fetchedResultsController;
@property (nonatomic, strong) UIBarButtonItem * addButton;

@property (nonatomic, weak) IBOutlet STSRootViewViewController_iPad * homeScreenVC;
@property (nonatomic, strong) UIPopoverController * popoverController;
@property (nonatomic, strong) UIColor			   * defaultTintColor;

@property (nonatomic, weak) IBOutlet UISegmentedControl* segmentedControl;

- (void) setSettingLabelText:(NSString *) value;
- (void) pushDetailControllerForSwimmer: (NSManagedObject *) swimmer;
- (IBAction) handleEditTapped;
- (IBAction) handleAddTapped;
@end


@implementation STSTimeStandardAndSwimmerController

@synthesize homeScreenVC;
@synthesize popoverController;

@synthesize swimmerSettingLabelText;

@synthesize addButton;

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
    
    self.title = @"Times & Swimmers";
    
    
    // time standards
    [self setSettingLabelText: @"Time Standard"];
	
	STSTimeStandardDataAccess * timeStandardDataAccess = [STSTimeStandardDataAccess sharedDataAccess];
	
	if (timeStandardDataAccess != nil) {
        _settingList = [timeStandardDataAccess getAllTimeStandardNames];
	}
	else {
		NSLog(@"Time Standard Data Access is nil. Cannot load view properly");
	}
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.editButtonItem setAction:@selector(handleEditTapped)];
    
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                    target:self
                                                                    action:@selector(handleAddTapped)];
    self.addButton.tintColor = [UIColor colorWithRed:0.796 green:0.267 blue:0.298 alpha:1.000];
    // don't display the add button until we are in edit mode
    
	[self setSettingLabelText: @"Swimmer"];
}


- (void)viewWillAppear:(BOOL)animated
{
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
		self.timeStandardSettingLabelText = @"Time Standard";
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
    [[STSSwimmerDataAccess sharedDataAccess] saveContext];
    
    // Get the storyboard named secondStoryBoard from the main bundle:
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    // Load the view controller with the identifier string myTabBar
    // Change UIViewController to the appropriate class
    UIViewController *destinationViewController = (UIViewController *)[secondStoryBoard instantiateViewControllerWithIdentifier:@"STSSwimmerDetailViewController"];
    
    UINavigationController * navController = [[UINavigationController alloc]initWithRootViewController:destinationViewController];
	
    // Pass the selected object to the new view controller.
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:navController];
    [self.popoverController presentPopoverFromRect:self.view.bounds
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
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
    UIColor * tableHeaderBackgroundColor = [UIColor colorWithRed:0.337 green:0.369 blue:0.706 alpha:1.000];
    UIColor * tableHeaderForegroundColor = [UIColor whiteColor];
    
    CGRect headerFrame = CGRectMake(0.0f, 0.0f, 300.0f, 36.0f);
    CGRect labelFrame = CGRectMake(10.0f, 4.0f, 290.0f, 26.0f);
    UIView * headerView = [[UIView alloc] initWithFrame: headerFrame];
    [headerView setBackgroundColor:tableHeaderBackgroundColor];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [headerLabel setTextColor:tableHeaderForegroundColor];
    [headerLabel setBackgroundColor: tableHeaderBackgroundColor];
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
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView registerNib:[STSSwimmerListTableViewCell nib]
    forCellReuseIdentifier:[STSSwimmerListTableViewCell cellIdentifier]];
    [tableView registerNib:[STSSwimmerListEditTableViewCell nib]
    forCellReuseIdentifier:[STSSwimmerListEditTableViewCell cellIdentifier]];
    [tableView registerNib:[STSTimeStandardHomeScreenTableCell nib]
    forCellReuseIdentifier:[STSTimeStandardHomeScreenTableCell cellIdentifier]];
    
    static NSManagedObject * homeScreenValues = nil;
    if (homeScreenValues == nil) {
        [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenValues];
    }
    
    UITableViewCell *cell = nil;
    NSUInteger section = [indexPath section];
    
    switch (section) {
        case timeStandardSection: {
            cell = [STSTimeStandardHomeScreenTableCell cellForTableView:tableView];
            // Configure the cell...
            NSUInteger row = [indexPath row];
            cell.textLabel.text = _settingList[row];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            
            // lastIndexPath is nil when the view loads for the first time.
            // see if any time standard has been saved; this will be pre-selected
            if (_lastIndexPath == nil) {
                NSString * tempStandardName = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenTimeStandard];
                NSInteger savedTimeStandard = [_settingList indexOfObject:tempStandardName];
                if (savedTimeStandard == row) {
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
                cell = [STSSwimmerListTableViewCell cellForTableView:tableView];
            }
            else {
                cell = [STSSwimmerListEditTableViewCell cellForTableView:tableView];
            }
            
            // the fetched results controller is not expecting there to be two sections, so we must create
            // an indexPath which the fetched results controller can understand
            NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:indexPath.row
                                                            inSection:0];
            NSManagedObject * thisCellSwimmer = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
            [(STSSwimmerListTableViewCell*)cell bindToSwimmer:thisCellSwimmer];
            break;
        }
        default:
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"defaultTableViewCell"];
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

- (void)   tableView:(UITableView *)tableView
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    
    switch (section) {
        case timeStandardSection:
            // we should never be here, but to be save include the case and take no action
            break;
        case swimmerSection: {
            if (editingStyle == UITableViewCellEditingStyleDelete) {
                // the fetched results controller is not expecting there to be two sections, so we must create
                // an indexPath which the fetched results controller can understand
                NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:indexPath.row
                                                                inSection:0];
                
                // Delete the object from Core Data
                NSManagedObject * swimmer = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
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
            
            break;
        }
        default:
            break;
    }
    NSNotification * notification = [NSNotification notificationWithName:STSHomeScreenValuesChangedKey
                                                                  object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
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
                _lastIndexPath = indexPath;
                self.settingValue = _settingList[newRow];
                
                NSManagedObject * tempHomeScreenValues = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenValues];
                [tempHomeScreenValues setValue:_settingValue forKey:@"homeScreenStandardName"];
                
                [[STSSwimmerDataAccess sharedDataAccess] saveContext];
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
            
            NSManagedObject * homeScreenValues = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenValues];
            [homeScreenValues setValue:currentSwimmer forKey:@"homeScreenSwimmer"];
            
            [[STSSwimmerDataAccess sharedDataAccess] saveContext];
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

- (IBAction) handleEditTapped {
	if (self.editing) {
		[self setEditing:NO animated:YES];
		self.navigationItem.leftBarButtonItem = nil;
        
        NSUInteger timeStandardRows = [self tableView:self.tableView numberOfRowsInSection:timeStandardSection];
        if (timeStandardRows > 0) {
            NSIndexPath * firstTimeStandardIndexPath = [NSIndexPath indexPathForRow:0 inSection:timeStandardSection];
            [self.tableView scrollToRowAtIndexPath:firstTimeStandardIndexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
        }
	}
	else {
		[self setEditing:YES animated:YES];
		self.navigationItem.leftBarButtonItem = self.addButton;
        
        NSUInteger swimmerRows = [self tableView:self.tableView numberOfRowsInSection:swimmerSection];
        if (swimmerRows > 0) {
            NSIndexPath * firstSwimmerIndexPath = [NSIndexPath indexPathForRow:0 inSection:swimmerSection];
            [self.tableView scrollToRowAtIndexPath:firstSwimmerIndexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
        }
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
    // the fetched results controller is not expecting there to be two sections, so we must create
    // an indexPath which the fetched results controller can understand
    NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:indexPath.row
                                                    inSection:0];
    
	NSManagedObject * swimmer = [[self fetchedResultsController] objectAtIndexPath:newIndexPath];
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
	
	switch (type) {
		case NSFetchedResultsChangeInsert: {
            // map from fetchedResultsController space to tableView space
            NSIndexPath * mappedIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row
                                                               inSection:swimmerSection];
			array = @[mappedIndexPath];
			[[self tableView] insertRowsAtIndexPaths:array
									withRowAnimation:UITableViewRowAnimationFade];
			break;
        }
		case NSFetchedResultsChangeDelete: {
            // map from fetchedResultsController space to tableView space
            NSIndexPath * mappedIndexPath = [NSIndexPath indexPathForRow:indexPath.row
                                                               inSection:swimmerSection];
			array = @[mappedIndexPath];
			[[self tableView] deleteRowsAtIndexPaths:array
									withRowAnimation:UITableViewRowAnimationFade];
			break;
        }
		case NSFetchedResultsChangeMove: {
            // map from fetchedResultsController space to tableView space
            NSIndexPath * mappedIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row
                                                               inSection:swimmerSection];
			array = @[mappedIndexPath];
			[[self tableView] deleteRowsAtIndexPaths:array
									withRowAnimation:UITableViewRowAnimationFade];
            
            // map from fetchedResultsController space to tableView space
            NSIndexSet *section = [NSIndexSet indexSetWithIndex:[mappedIndexPath section]];
			[[self tableView] reloadSections:section
							withRowAnimation:UITableViewRowAnimationFade];
			break;
        }
		case NSFetchedResultsChangeUpdate: {
            // map from fetchedResultsController space to tableView space
            NSIndexPath * mappedIndexPath = [NSIndexPath indexPathForRow:indexPath.row
                                                               inSection:swimmerSection];
            // map from tableView space to fetchedResultsController space
            NSIndexPath * reverseMappedIdexPath = [NSIndexPath indexPathForRow:indexPath.row
                                                                     inSection:0];
            STSSwimmerListTableViewCell * cell = (STSSwimmerListTableViewCell*)[[self tableView] cellForRowAtIndexPath:mappedIndexPath];
            NSManagedObject * currentSwimmer = [[self fetchedResultsController] objectAtIndexPath:reverseMappedIdexPath];
            [cell bindToSwimmer:currentSwimmer];
			break;
        }
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




@end
