//
//  SwimmerDetailViewController.m
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "STSSwimmerDetailViewController.h"
#import "STSSwimmerDataAccess.h"
#import "STSTimeStandardDataAccess.h"
#import "STSSwimmerPhotoViewController.h"
#import "STSSwimmerHomeScreenTableViewCell.h"



typedef NS_ENUM(NSUInteger, STSSwimmerDetailTableSections) {
    swimmerGenderSection = 0,
    swimmerAgeGroupSection = 1,
    STSSwimmerDetailTableTotalSections = 2,
    swimmerNameSection = 5
};

static NSString * const kSwimmerDetailViewToSwimmerPhotoViewSegue = @"SwimmerDetailViewToSwimmerPhotoViewSegue";


@interface STSSwimmerDetailViewController()
@property (nonatomic, strong) NSManagedObject * swimmer;
@property (nonatomic, strong) NSArray			* genderList;
@property (nonatomic, strong) NSArray			* ageList;
@property (nonatomic, strong) NSIndexPath		* lastGenderPath;
@property (nonatomic, strong) NSIndexPath		* lastAgeGroupPath;
@property (nonatomic, weak)   NSString          * initialGender;
@property (nonatomic, weak)   NSString          * initialAge;
@end

@implementation STSSwimmerDetailViewController

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];

    self.swimmer = [[STSSwimmerDataAccess sharedDataAccess] currentSwimmer];
    
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// the ageList and genderList fields depend on the current TimeStandard
	// so first find the current TimeStandard then create these lists
	NSString * tempTimeStandardName = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenTimeStandard];
	tempTimeStandardName = (tempTimeStandardName != nil) ? tempTimeStandardName : @"";
	
	STSTimeStandardDataAccess * timeStandardDataAccess = [STSTimeStandardDataAccess sharedDataAccess];
	self.ageList = [timeStandardDataAccess getAllAgeGroupNames:tempTimeStandardName];
	self.genderList = @[@"male", @"female"];
	
	self.nameTextField.text = [_swimmer valueForKey:@"swimmerName"];

	[self displaySwimmerPhoto];
}


 - (void)viewWillAppear:(BOOL)animated {
	 [super viewWillAppear:animated];
	 self.nameTextField.text = [_swimmer valueForKey:@"swimmerName"];
	 [self displaySwimmerPhoto];
     
     [self setInitialGender: [_swimmer valueForKey:@"swimmerGender"]];
     [self setInitialAge: [_swimmer valueForKey:@"swimmerAgeGroup"]];
 }

- (void)viewWillDisappear:(BOOL)animated {
    // we need to notify anyone who care is the critical home screen values have changed
    NSString * finalGender = [_swimmer valueForKey:@"swimmerGender"];
    NSString * finalAge = [_swimmer valueForKey:@"swimmerAgeGroup"];

    BOOL gendersEqual = [finalGender isEqualToString:self.initialGender];
    BOOL agesEqual = [finalAge isEqualToString:self.initialAge];
    
    if ((gendersEqual == NO) || (agesEqual == NO)) {
        NSNotification * notification = [NSNotification notificationWithName:STSHomeScreenValuesChangedKey
                                                                      object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }

    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - private helpler methods

- (void) setSwimmer:(NSManagedObject *)value; {
    _swimmer = value;
}

- (void) setAgeList: (NSArray *) value; {
    _ageList = value;
}

- (void) setGenderList: (NSArray *) value; {
    _genderList = value;
}

- (void) setInitialGender: (NSString *) value; {
    _initialGender = value;
}

- (void) setInitialAge: (NSString *) value; {
    _initialAge = value;
}

- (void) displaySwimmerPhoto {
	if(_swimmer == nil) {
		return;
	}
	
	NSManagedObject * photo = [_swimmer valueForKey:@"swimmerThumbnailPhoto"];
	if (photo == nil) {
		return;
	}
	
	UIImage * photoImage = [photo valueForKey:@"photoImage"];
	if (photoImage == nil) {
		return;
	}
	
	_imageView.image = photoImage;
}


#pragma mark - text field delegate

- (IBAction) textFieldDoneEditing:(id)sender {
	[_swimmer setValue:self.nameTextField.text forKey:@"swimmerName"];
    
    // let anyone interested know the name has changed
    NSNotification * notification = [NSNotification notificationWithName:STSSwimmerNameChangedKey
                                                                  object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction) backgroundTapped:(id)sender {
	[self.nameTextField resignFirstResponder];
	[self textFieldDoneEditing:sender];
}

#pragma mark -  Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSUInteger value = STSSwimmerDetailTableTotalSections;
    return value;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (section) {
		case swimmerGenderSection:
			return [_genderList count];
		case swimmerAgeGroupSection:
			return [_ageList count];
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
			timeStandardName = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenTimeStandard];
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
    
    static NSString * cellReuseIdentifier = @"detailViewCell";
    [tableViewParam registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuseIdentifier];
    UITableViewCell *cell = [tableViewParam dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    // Configure the cell...
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	NSUInteger oldRow = 0;
    
	switch (section) {
		case swimmerGenderSection:
			// configure the cell.
			cell.textLabel.text = _genderList[row];
			
			// lastGenderPath is nil when the view loads for the first time.
			// see if any gender has been saved; this will be pre-selected
			if (_lastGenderPath == nil) {
				NSInteger savedGenderIndex = [_genderList indexOfObject:[_swimmer valueForKey:@"swimmerGender"]];
				if (row == savedGenderIndex) {
					self.lastGenderPath = indexPath;
				}
			}
			oldRow = [_lastGenderPath row];
			cell.accessoryType = (_lastGenderPath != nil && oldRow == row) ?
			UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
			break;
		case swimmerAgeGroupSection:
			// configure the cell.
			cell.textLabel.text = _ageList[row];
			
			// lastAgeGroupPath is nil when the view loads for the first time.
			// see if any Age Group has been saved; this will be pre-selected
			if (_lastAgeGroupPath == nil) {
				NSInteger savedAgeGroupIndex = [_ageList indexOfObject:[_swimmer valueForKey:@"swimmerAgeGroup"]];
				if (row == savedAgeGroupIndex) {
					_lastAgeGroupPath = indexPath;
				}
			}
			oldRow = [_lastAgeGroupPath row];
			cell.accessoryType = (_lastAgeGroupPath != nil && oldRow == row) ?
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableViewParam didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSUInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	switch (section) {
		case swimmerGenderSection:
			if (_lastGenderPath != indexPath) {
				UITableViewCell * oldCell = [tableViewParam cellForRowAtIndexPath: _lastGenderPath];
				oldCell.accessoryType = UITableViewCellAccessoryNone;
				// remember to change the style of the old cell BEFORE resetting the old cell's path
				self.lastGenderPath = indexPath;
				[_swimmer setValue:_genderList[row] forKey:@"swimmerGender"];
                
                UITableViewCell * newCell = [tableViewParam cellForRowAtIndexPath:indexPath];
				newCell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			[tableViewParam deselectRowAtIndexPath: indexPath animated: YES];
			break;
		case swimmerAgeGroupSection:
			if (_lastAgeGroupPath != indexPath) {
				UITableViewCell * oldCell = [tableViewParam cellForRowAtIndexPath: _lastAgeGroupPath];
				oldCell.accessoryType = UITableViewCellAccessoryNone;
				// remember to change the style of the old cell BEFORE resetting the old cell's path
				self.lastAgeGroupPath = indexPath;
				[_swimmer setValue:_ageList[row] forKey:@"swimmerAgeGroup"];
                
                UITableViewCell * newCell = [tableViewParam cellForRowAtIndexPath:indexPath];
				newCell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
			[tableViewParam deselectRowAtIndexPath: indexPath animated: YES];
			break;
		default:
			break;
	}
}

#pragma mark - Segues.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueId = [segue identifier];
    
    if([segueId isEqualToString:kSwimmerDetailViewToSwimmerPhotoViewSegue]){
        // first, remember to save any un-saved changes from editing the swimmer's name
        [_swimmer setValue: _nameTextField.text forKey: @"swimmerName"];
        [[STSSwimmerDataAccess sharedDataAccess] saveContext];
    }
}



@end
