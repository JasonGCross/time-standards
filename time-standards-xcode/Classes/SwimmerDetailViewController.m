//
//  SwimmerDetailViewController.m
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SwimmerDetailViewController.h"
#import "SwimmingTimeStandardsAppDelegate.h"
#import "TimeStandardDataAccess.h"
#import "SwimmerPhotoViewController.h"

#define swimmerNameSection 5
#define swimmerGenderSection 0
#define swimmerAgeGroupSection 1


@implementation SwimmerDetailViewController

@synthesize nameTextField;
@synthesize tableView;
@synthesize imageView;


- (void) displaySwimmerPhoto {
	if(swimmer == nil) {
		return;
	}
	
	NSManagedObject * photo = [swimmer valueForKey:@"swimmerPhoto"];
	if (photo == nil) {
		return;
	}
	
	UIImage * photoImage = [photo valueForKey:@"photoImage"];
	if (photoImage == nil) {
		return;
	}
	
	imageView.image = photoImage;
}

#pragma mark -
#pragma mark View lifecycle

- (id) init {
    self = [super initWithNibName:@"SwimmerDetailView" bundle:nil];
    if(self) {
    }
    return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	appDelegate = (SwimmingTimeStandardsAppDelegate *)[[UIApplication sharedApplication]
													   delegate];
    swimmer = [appDelegate currentSwimmer];
    
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// the ageList and genderList fields depend on the current TimeStandard
	// so first find the current TimeStandard then create these lists
	NSString * tempTimeStandardName = [appDelegate getHomeScreenTimeStandard];
	tempTimeStandardName = (tempTimeStandardName != nil) ? tempTimeStandardName : @"";
	
	TimeStandardDataAccess * timeStandardDataAccess = [appDelegate timeStandardDataAccess];
	ageList = [[timeStandardDataAccess getAllAgeGroupNames:tempTimeStandardName] retain];
	genderList = [[NSArray alloc] initWithObjects: @"male", @"female", nil];
	
	self.nameTextField.text = [swimmer valueForKey:@"swimmerName"];

	[self displaySwimmerPhoto];
}


 - (void)viewWillAppear:(BOOL)animated {
	 [super viewWillAppear:animated];
	 self.nameTextField.text = [swimmer valueForKey:@"swimmerName"];
	 [self displaySwimmerPhoto];
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


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark text field delegate

- (IBAction) textFieldDoneEditing:(id)sender {
	[swimmer setValue:nameTextField.text forKey:@"swimmerName"];
}

- (IBAction) backgroundTapped:(id)sender {
	[nameTextField resignFirstResponder];
	[swimmer setValue: nameTextField.text forKey: @"swimmerName"];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (section) {
		case swimmerGenderSection:
			return [genderList count];
		case swimmerAgeGroupSection:
			return [ageList count];
		default:
			return 0;
	}
	return 0;
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString * sectionTitle = nil;
	NSString * timeStandardName = nil;
	switch (section) {
		case swimmerGenderSection:
			sectionTitle = @"Gender";
			break;
		case swimmerAgeGroupSection:
			timeStandardName = [appDelegate getHomeScreenTimeStandard];
			if (timeStandardName == nil) {
				sectionTitle = @"Please go back and select a Time Standard before you can pick an age group.";
			}
			else {
				sectionTitle = [NSString stringWithFormat:@"Age Group for %@", timeStandardName];
			}
			break;
		default:
			break;
	}
	return sectionTitle;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableViewParam cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SwimmerDetailCell";
    
    UITableViewCell *cell = nil;
    
    // Configure the cell...
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	NSUInteger oldRow = 0;
	switch (section) {
		case swimmerGenderSection:
			cell = [tableViewParam dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
											   reuseIdentifier:CellIdentifier] autorelease];
			}
			// configure the cell.
			cell.textLabel.text = [genderList objectAtIndex:row];
			
			// lastGenderPath is nil when the view loads for the first time.
			// see if any gender has been saved; this will be pre-selected
			if (lastGenderPath == nil) {
				NSInteger savedGenderIndex = [genderList indexOfObject:[swimmer valueForKey:@"swimmerGender"]];
				if (row == savedGenderIndex) {
					lastGenderPath = indexPath;
				}
			}
			oldRow = [lastGenderPath row];
			cell.accessoryType = (lastGenderPath != nil && oldRow == row) ?
			UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
			break;
		case swimmerAgeGroupSection:
			cell = [tableViewParam dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
											   reuseIdentifier:CellIdentifier] autorelease];
			}
			// configure the cell.
			cell.textLabel.text = [ageList objectAtIndex:row];
			
			// lastAgeGroupPath is nil when the view loads for the first time.
			// see if any Age Group has been saved; this will be pre-selected
			if (lastAgeGroupPath == nil) {
				NSInteger savedAgeGroupIndex = [ageList indexOfObject:[swimmer valueForKey:@"swimmerAgeGroup"]];
				if (row == savedAgeGroupIndex) {
					lastAgeGroupPath = indexPath;
				}
			}
			oldRow = [lastAgeGroupPath row];
			cell.accessoryType = (lastAgeGroupPath != nil && oldRow == row) ?
			UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
			break;
		default:
			break;
	}

    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger section = [indexPath section];
	if (section == swimmerNameSection) {
		 return YES;
	}
	 
	// Return NO if you do not want the specified item to be editable.
	return NO;
}
 
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath {
	 
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

- (void)tableView:(UITableView *)tableViewParam didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSUInteger section = [indexPath section];
	int row = [indexPath row];
	
	switch (section) {
		case swimmerGenderSection:
			if (lastGenderPath != indexPath) {
				UITableViewCell * newCell = [tableViewParam cellForRowAtIndexPath:indexPath];
				newCell.accessoryType = UITableViewCellAccessoryCheckmark;
				UITableViewCell * oldCell = [tableViewParam cellForRowAtIndexPath: lastGenderPath];
				oldCell.accessoryType = UITableViewCellAccessoryNone;
				// remember to change the style of the old cell BEFORE resetting the old cell's path
				lastGenderPath = indexPath;
				[swimmer setValue:[genderList objectAtIndex:row] forKey:@"swimmerGender"];;
			}
			[tableViewParam deselectRowAtIndexPath: indexPath animated: YES];
			break;
		case swimmerAgeGroupSection:
			if (lastAgeGroupPath != indexPath) {
				UITableViewCell * newCell = [tableViewParam cellForRowAtIndexPath:indexPath];
				newCell.accessoryType = UITableViewCellAccessoryCheckmark;
				UITableViewCell * oldCell = [tableViewParam cellForRowAtIndexPath: lastAgeGroupPath];
				oldCell.accessoryType = UITableViewCellAccessoryNone;
				// remember to change the style of the old cell BEFORE resetting the old cell's path
				lastAgeGroupPath = indexPath;
				[swimmer setValue:[ageList objectAtIndex:row] forKey:@"swimmerAgeGroup"];
			}
			[tableViewParam deselectRowAtIndexPath: indexPath animated: YES];
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark ImagePicker view

- (IBAction) imageViewTapped:(id)sender {
	// first, remember to save any un-saved changes from editing the swimmer's name
	[swimmer setValue: nameTextField.text forKey: @"swimmerName"];
	[appDelegate saveContext];
	
	// Navigation logic may go here. Create and push another view controller.
	SwimmerPhotoViewController *swimmerPhotoViewController = [[SwimmerPhotoViewController alloc] 
														 initWithNibName:@"SwimmerPhotoViewController"
														 bundle:nil];
    [appDelegate setCurrentSwimmer:swimmer];
	
    // Pass the selected object to the new view controller.
	[self.navigationController pushViewController:swimmerPhotoViewController animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.imageView = nil;
}


- (void)dealloc {
	[ageList release];
	[genderList release];
    [super dealloc];
}


@end
