//
//  RootViewController.m
//  PNS Times
//
//  Created by JASON CROSS on 7/18/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "TopLevelSettingViewController.h"
#import "GenderController.h"
#import "AgeController.h"
#import "TimeStandardController.h"
#import "TimeStandardDataAccess.h"

@implementation RootViewController

@synthesize controllers, pickerView, label, tableView;
@synthesize strokes, courses, distances;
@synthesize previousStroke, previousDistance, previousCourse;
@synthesize timeStandardDataAccess;

- (void) populateStrokeComponent {
	self.strokes = [timeStandardDataAccess getAllStrokeNamesForStandardName:[timeStandardController settingValue]
																  andGender:[genderController settingValue]
															andAgeGroupName:[ageController settingValue]];
	[self.pickerView reloadComponent: PNSStrokeComponent];
	[self.pickerView selectRow:0 inComponent:PNSStrokeComponent animated:YES];
	self.previousStroke = [self.strokes objectAtIndex:0];
}

- (void) populateDistanceComponent {
	self.distances = [timeStandardDataAccess getDistancesForStandardName:[timeStandardController settingValue]
															   andGender:[genderController settingValue]
														 andAgeGroupName:[ageController settingValue]
														   andStrokeName:[self.strokes objectAtIndex:0]
															   andFormat:nil];
	[self.pickerView reloadComponent:PNSDistanceComponent];
	[self.pickerView selectRow:0 inComponent:PNSDistanceComponent animated:YES];
	self.previousDistance = [self.distances objectAtIndex:0];	
}

- (void) populateCourseComponent {
	self.courses = [timeStandardDataAccess getFormatForStandardName:[timeStandardController settingValue]
														  andGender:[genderController settingValue]
													andAgeGroupName:[ageController settingValue]
														andDistance:[self.distances objectAtIndex: 0]
													  andStrokeName:[self.strokes objectAtIndex:0]];
	[self.pickerView reloadComponent:PNSCourseComponent];
	[self.pickerView selectRow:0 inComponent:PNSCourseComponent animated:YES];
	self.previousCourse = [self.courses objectAtIndex:0];	
}

- (NSUInteger) rowToSelectWhenReloadingComponent: (NSUInteger) component {
	int newRow = 0;
	NSArray * arrayToSearch = nil;
	NSString * stringToMatch = nil;
	switch (component) {
		case PNSDistanceComponent:
			arrayToSearch = self.distances;
			stringToMatch = self.previousDistance;
			break;
		case PNSStrokeComponent:
			arrayToSearch = self.strokes;
			stringToMatch = self.previousStroke;
			break;
		case PNSCourseComponent:
			arrayToSearch = self.courses;
			stringToMatch = self.previousCourse;
			break;
		default:
			break;
	}
	for (NSString * nextVal in arrayToSearch) {
		NSComparisonResult result = [nextVal compare: stringToMatch];
		if (result == NSOrderedSame) {
			newRow = [arrayToSearch indexOfObject:nextVal];
			break;
		}
	}
	return newRow;
}

- (void) refreshDistanceComponent {
	self.distances = [timeStandardDataAccess 
					  getDistancesForStandardName:[timeStandardController settingValue]
					  andGender:[genderController settingValue]
					  andAgeGroupName:[ageController settingValue]
					  andStrokeName:[self.strokes objectAtIndex:
									 [self.pickerView selectedRowInComponent:PNSStrokeComponent]]
					  andFormat:[self.courses objectAtIndex:
								 [self.pickerView selectedRowInComponent:PNSCourseComponent]]];
	[self.pickerView reloadComponent:PNSDistanceComponent];
	if ([self.distances count] > 0) {
		NSUInteger newRow = [self rowToSelectWhenReloadingComponent: PNSDistanceComponent];
		[self.pickerView selectRow:newRow inComponent:PNSDistanceComponent animated:YES];
		self.previousDistance = [self.distances objectAtIndex:newRow];
	}
}

- (void) refreshCourseComponent {
	self.courses = [timeStandardDataAccess 
					getFormatForStandardName:[timeStandardController settingValue]
					andGender:[genderController settingValue]
					andAgeGroupName:[ageController settingValue]
					andDistance:[self.distances objectAtIndex:
								 [self.pickerView selectedRowInComponent:PNSDistanceComponent]]
					andStrokeName:[self.strokes objectAtIndex:
								   [self.pickerView selectedRowInComponent:PNSStrokeComponent]]];
	[self.pickerView reloadComponent:PNSCourseComponent];
	if ([self.courses count] > 0) {
		NSUInteger newRow = [self rowToSelectWhenReloadingComponent:PNSCourseComponent];
		[self.pickerView selectRow:newRow inComponent:PNSCourseComponent animated:YES];
		self.previousCourse = [self.courses objectAtIndex:newRow];
	}
}

- (void) refreshPickerRows {
	if ((self.distances != nil) && ([self.distances count] == 0)) {
		if (([genderController settingValue] != nil) && ([ageController settingValue] != nil)) {
			[self populateStrokeComponent];
			[self populateDistanceComponent];
			[self populateCourseComponent];
			return;
		}
	}
	else {
		[self refreshDistanceComponent];
		[self refreshCourseComponent];
	}
}

- (void) updateTimeLabel {
	if ((self.distances == nil) || ([self.distances count] == 0) ||
		(self.strokes == nil) || ([self.strokes count] == 0) ||
		(self.courses == nil) || ([self.courses count] == 0)) {
		return;
	}
	NSString * timeStr = [timeStandardDataAccess getTimeForStandardName:[timeStandardController settingValue]
															  andGender:[genderController settingValue] 
														andAgeGroupName:[ageController settingValue]
															andDistance:[self.distances objectAtIndex:
																		 [self.pickerView selectedRowInComponent:PNSDistanceComponent]]
														  andStrokeName:[self.strokes objectAtIndex:
																		 [self.pickerView selectedRowInComponent:PNSStrokeComponent]]
															  andFormat:[self.courses objectAtIndex:
																		 [self.pickerView selectedRowInComponent:PNSCourseComponent]]];
	self.label.text = timeStr;
	[timeStr release];
}

- (void) refreshTopLevelSettingValues {
	// the Time Standard determines what the age group fields should be
	if ((timeStandardController != nil) && (timeStandardController.settingValue != nil)) {
		// only change if the age has NOT been previously set
		if ((ageController != nil) && (ageController.settingValue == nil)) {
			ageController.timeStandardName = timeStandardController.settingValue;
			NSArray * ageGroups = [timeStandardDataAccess 
								   getAgeGroupNames: timeStandardController.settingValue];
			if ([ageGroups count] > 0) {
				ageController.settingValue = [ageGroups objectAtIndex:0];
			}
		}
		// only change if the gender has NOT been previously set
		if((genderController != nil) && (genderController.settingValue == nil)) {
			genderController.settingValue = @"male";
		}
	}
}

#pragma mark -
#pragma mark View lifecycle

- (void) applicationWillTerminate: (NSNotification *) notification {
	[timeStandardDataAccess closeDataBase];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.title = @"Time Standards";
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	self.timeStandardDataAccess = [[TimeStandardDataAccess alloc] init];
	[timeStandardDataAccess openDataBase];
	
	// time standards
	timeStandardController = [TimeStandardController timeControllerWithDefaults];
	timeStandardController.timeStandardDataAccess = self.timeStandardDataAccess;
	timeStandardController.title = @"Time Standard";
	[array addObject: timeStandardController];
	
	// gender
	genderController = [GenderController genderControllerWithDefaults];
	genderController.title = @"Gender Settings";
	[array addObject: genderController];

	// age
	ageController = [AgeController ageControllerWithDefaults];
	ageController.timeStandardDataAccess = self.timeStandardDataAccess;
	ageController.title = @"Age Settings";
	[array addObject:ageController];
	
	 self.controllers = array;
	[array release];
	
	self.strokes = [[NSArray alloc] init];
	self.courses = [[NSArray alloc] init];
	self.distances = [[NSArray alloc] init];

	
	UIApplication * app = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:app];
}



- (void)viewWillAppear:(BOOL)animated {
	[self refreshTopLevelSettingValues];
	[tableView reloadData];
	[self refreshPickerRows];
	[self updateTimeLabel];
    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.controllers count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableViewCell 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SettingCell";
    
    UITableViewCell *cell = [tableViewCell dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:CellIdentifier] autorelease];
		
		CGRect settingKeyRect = CGRectMake(10, 12, 110, 17);
		UILabel *settingKeyLabel = [[UILabel alloc] initWithFrame:settingKeyRect];
		settingKeyLabel.text = UITextAlignmentLeft;
		settingKeyLabel.tag = PNSTimesSettingKeyLabelTag;
		settingKeyLabel.font = [UIFont boldSystemFontOfSize:14];
		settingKeyLabel.textColor = [UIColor blackColor];
		[cell.contentView addSubview:settingKeyLabel];
		[settingKeyLabel release];
		
		CGRect settingValueRect = CGRectMake(110, 12, 160, 17);
		UILabel *settingValueLabel = [[UILabel alloc] initWithFrame:settingValueRect];
		settingValueLabel.textAlignment = UITextAlignmentRight;
		settingValueLabel.tag = PNSTimesSettingValueLabelTag;
		settingValueLabel.font = [UIFont systemFontOfSize:14];
		settingValueLabel.textColor = [UIColor colorWithRed:0.207f green:0.329f blue:0.53f alpha:1.0f];
		[cell.contentView addSubview: settingValueLabel];
		[settingValueLabel release];
    }
    
	// Configure the cell.
	NSInteger row = [indexPath row];
	
	TopLevelSettingViewController *controller = [controllers objectAtIndex:row];
	
	UILabel * settingKey = (UILabel *) [cell.contentView viewWithTag: PNSTimesSettingKeyLabelTag];
	settingKey.text = [controller settingName];

	UILabel * settingValue = (UILabel *) [cell.contentView viewWithTag: PNSTimesSettingValueLabelTag];
	settingValue.text = [controller settingValue];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	TopLevelSettingViewController *detailViewController = [self.controllers 
															 objectAtIndex:row];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController 
										  animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.controllers = nil;
	self.distances = nil;
	self.courses = nil;
	self.strokes = nil;
	self.previousStroke = nil;
	self.previousDistance = nil;
	self.previousCourse = nil;
	self.pickerView = nil;
	self.label = nil;
	self.tableView = nil;
}


- (void)dealloc {
	[controllers release];
	[timeStandardController release];
	[genderController release];
	[ageController release];
	[distances release];
	[courses release];
	[strokes release];
	[previousStroke release];
	[previousDistance release];
	[previousCourse release];
	[pickerView release];
	[label release];
	[tableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Picker Data Source Methods

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 3;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView 
 numberOfRowsInComponent:(NSInteger)component {
	switch (component) {
		case PNSDistanceComponent:
			return [self.distances count];
			break;
		case PNSStrokeComponent:
			return [self.strokes count];
			break;
		case PNSCourseComponent:
			return [self.courses count];
			break;
		default:
			return 0;
			break;
	}
	
}

#pragma mark Picker Delegate Methods

- (NSString *) pickerView:(UIPickerView *)pickerView 
			  titleForRow:(NSInteger)row 
			 forComponent:(NSInteger)component {
	switch (component) {
		case PNSDistanceComponent:
			return [self.distances objectAtIndex:row];
			break;
		case PNSStrokeComponent:
			return [self.strokes objectAtIndex:row];
			break;
		case PNSCourseComponent:
			return [self.courses objectAtIndex:row];
			break;
		default:
			return @"";
			break;
	}
}


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row 
		inComponent:(NSInteger)component {
	if ((self.distances == nil) || ([self.distances count] == 0)) {
		[self populateStrokeComponent];
		[self.pickerView selectRow:0 inComponent:PNSDistanceComponent animated:YES];
	}
	if ((self.strokes == nil) || ([self.strokes count] == 0)) {
		[self populateStrokeComponent];
		[self.pickerView selectRow:0 inComponent:PNSStrokeComponent animated:YES];
	}
	if ((self.courses == nil) || ([self.courses count] == 0)) {
		[self populateCourseComponent];
		[self.pickerView selectRow:0 inComponent:PNSCourseComponent animated:YES];
	}
	switch (component) {
		case PNSDistanceComponent:
			[self refreshCourseComponent];
			self.previousDistance = [self.distances objectAtIndex:
									 [self.pickerView selectedRowInComponent:PNSDistanceComponent]];
			break;
		case PNSStrokeComponent:
			[self refreshDistanceComponent];
			[self refreshCourseComponent];
			self.previousStroke = [self.strokes objectAtIndex:
								   [self.pickerView selectedRowInComponent:PNSStrokeComponent]];
			break;
		case PNSCourseComponent:
			[self refreshDistanceComponent];
			self.previousCourse = [self.courses objectAtIndex:
								   [self.pickerView selectedRowInComponent:PNSCourseComponent]];
		default:
			break;
	}
	[self updateTimeLabel];
}

@end

