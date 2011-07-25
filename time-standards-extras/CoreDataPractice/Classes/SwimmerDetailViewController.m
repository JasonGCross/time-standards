//
//  SwimmerDetailViewController.m
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SwimmerDetailViewController.h"
#import "SwimmerPhotoViewController.h"

#define swimmerNameSection 0
#define swimmerGenderSection 1
#define swimmerAgeGroupSection 2

@implementation SwimmerDetailViewController

@synthesize swimmer;
@synthesize nameTextField;
@synthesize tableView;
@synthesize nibLoadedSwimmerNameCell;
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
	[imageView sizeToFit];
}

#pragma mark -
#pragma mark View lifecycle

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

	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	ageList = [[NSArray alloc] initWithObjects: @"10 & under", @"11 & 12", @"13 & 14", @"15 & over", nil];
	genderList = [[NSArray alloc] initWithObjects: @"male", @"female", nil];

	[self displaySwimmerPhoto];
}


 - (void)viewWillAppear:(BOOL)animated {
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


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark text field delegate

- (void) nameTextFieldFinishedEditing {
	[nameTextField resignFirstResponder];
	[swimmer setValue: nameTextField.text forKey: @"swimmerName"];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	[swimmer setValue: textField.text forKey: @"swimmerName"];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[swimmer setValue:textField.text forKey:@"swimmerName"];
}

- (IBAction) textFieldDoneEditing:(id)sender {
	[self textFieldDidEndEditing:(UITextField *)sender];
}

- (IBAction) backgroundTapped:(id)sender {
	[nameTextField resignFirstResponder];
	[swimmer setValue: nameTextField.text forKey: @"swimmerName"];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (section) {
		case swimmerNameSection:
			return 1;
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
	switch (section) {
		case 0:
			return @"Swimmer Name";
			break;
		case 1:
			return @"Swimmer Gender";
			break;
		case 2:
			return @"Swimmer Age Group";
			break;
		default:
			return @"";
			break;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableViewParam cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SwimmerDetailCell";
	static NSString *SwimmerNameCellIdentifier = @"SwimmerNameCell";
    
    UITableViewCell *cell = nil;
    
    // Configure the cell...
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	NSUInteger oldRow = 0;
	switch (section) {
		case swimmerNameSection:
			cell = [tableViewParam dequeueReusableCellWithIdentifier:SwimmerNameCellIdentifier];
			if (cell == nil) {
				[[NSBundle mainBundle] loadNibNamed:@"SwimmerNameTableCell"
											  owner:self 
											options:nil];
				cell = nibLoadedSwimmerNameCell;
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			// configure the cell.
			self.nameTextField.text = [swimmer valueForKey:@"swimmerName"];
			break;
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
		case swimmerNameSection:
			{
				//UITableViewCell * swimmerNameCell = [tableView cellForRowAtIndexPath:indexPath];
				//tableView.editing = YES;
				//swimmerNameCell.textLabel.userInteractionEnabled = YES;
				//swimmerNameCell.editing = YES;
				[self nameTextFieldFinishedEditing];
			}
			break;
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
	// Navigation logic may go here. Create and push another view controller.
	SwimmerPhotoViewController *swimmerPhotoViewController = [[SwimmerPhotoViewController alloc] 
														 initWithNibName:@"SwimmerPhotoViewController"
														 bundle:nil];
	[swimmerPhotoViewController setSwimmer:swimmer];
	
    // Pass the selected object to the new view controller.
	[self.navigationController pushViewController:swimmerPhotoViewController animated:YES];
	
	
	
	
	//if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//		self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//	}
//	else {
//		self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
//	}
//	self.imagePickerController.allowsEditing = YES;
//	[self presentModalViewController:self.imagePickerController animated: YES];
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
