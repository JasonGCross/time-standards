//
//  RootViewController.m
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "SwimmingTimesStandardsGlobals.h"
#import "SwimmingTimeStandardsAppDelegate.h"
#import "TimeStandardDataAccess.h"
#import "TimeStandardController.h"
#import "SwimmerController.h"


@implementation RootViewController

@synthesize controllers, pickerView, label;
@synthesize tableView;
@synthesize nibLoadedStandardCell, nibLoadedSwimmerCell;
@synthesize strokes, courses, distances;
@synthesize previousStroke, previousDistance, previousCourse;
@synthesize previousTimeStandard, previousAgeGroup, previousGender;


#pragma mark -
#pragma mark Initialization

- (id) init {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self = [super initWithNibName:@"RootViewController-ipad" bundle:nil];
    }
    else {
        self = [super initWithNibName:@"RootViewController" bundle:nil];
    }
    if(self) {
        self.title = @"PNS Time Standards";
        appDelegate = (SwimmingTimeStandardsAppDelegate *)[[UIApplication sharedApplication]
                                                           delegate];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        // time standards
        timeStandardController = [[TimeStandardController alloc] initWithStyle:UITableViewStyleGrouped];
        timeStandardController.settingLabelText = @"Time Standard";
        timeStandardController.title = @"Time Standard";
        [array addObject: timeStandardController];
        
        // swimmer
        swimmerController = [[SwimmerController alloc] initWithStyle:UITableViewStyleGrouped];
        swimmerController.settingLabelText = @"Swimmer";
        swimmerController.title = @"Swimmer";
        [array addObject: swimmerController];
        
        self.controllers = array;
        [array release];
        
        // picker columns
        NSArray * tempArray = [[NSArray alloc] init];
        self.strokes = tempArray;
        [tempArray release];
        tempArray = nil;
        tempArray = [[NSArray alloc] init];
        self.courses = tempArray;
        [tempArray release];
        tempArray = nil;
        tempArray = [[NSArray alloc] init];
        self.distances = tempArray;
        [tempArray release];
        tempArray = nil;
    }
    return self;
}

#pragma mark -
#pragma mark Private helper methods

- (NSString *) ValidateOrResetCurrentSwimmerAgeGroup {
	NSManagedObject * tempSwimmer = [appDelegate getHomeScreenSwimmer];
	if ((tempSwimmer == nil) || ([tempSwimmer valueForKey:@"swimmerAgeGroup"] == nil)) {
		return nil;
	}
	
	// the picker relies upon the current ageGroup existing in the picker rows
	BOOL ageGroupIsValid = [[appDelegate timeStandardDataAccess] timeStandard:[appDelegate getHomeScreenTimeStandard] 
                                                          doesContainAgeGroup:[tempSwimmer valueForKey:@"swimmerAgeGroup"]];
	if (ageGroupIsValid == NO) {
		[tempSwimmer setValue:nil forKey:@"swimmerAgeGroup"];
	}
	return [tempSwimmer valueForKey:@"swimmerAgeGroup"];
}

- (BOOL) homeScreenValuesHaveChanged {
	if ((self.previousTimeStandard == nil) || (self.previousAgeGroup == nil) || (self.previousGender == nil)) {
		return YES;
	}
	NSString * currentStandard = [appDelegate getHomeScreenTimeStandard];
	NSManagedObject * currentSwimmer = [appDelegate getHomeScreenSwimmer];
	NSString * currentGender = [currentSwimmer valueForKey:@"swimmerGender"];
	NSString * currentAgeGroup = [currentSwimmer valueForKey:@"swimmerAgeGroup"];
	
	if([self.previousTimeStandard isEqualToString: currentStandard] && 
			[self.previousAgeGroup isEqualToString: currentAgeGroup] && 
			[self.previousGender isEqualToString: currentGender]) {
		return NO;
	}
	return YES;
}

- (NSString *) getSelectedOrPreviousStroke {
    if ((nil == self.strokes) || ([self.strokes count] == 0)) {
        return nil;
    }
    
	// if there is no row currently selected, return the previous value
	if ([self.pickerView selectedRowInComponent:STSStrokeComponent] < 0) {
		// if there is no previous value, try to set it now
		if ((self.previousStroke == nil) && ([self.strokes count] > 0)) {
			self.previousStroke = [self.strokes objectAtIndex:0];
		}
		return self.previousStroke;
	}
	else {
		return [self.strokes objectAtIndex:
				[self.pickerView selectedRowInComponent:STSStrokeComponent]];
	}
}

- (NSString *) getSelectedOrPreviousDistance {
    if ((nil == self.distances) || ([self.distances count] == 0)) {
        return nil;
    }
	// if there is no row currently selected, return the previous value
	if ([self.pickerView selectedRowInComponent:STSDistanceComponent] < 0) {
		// if there  is no previous value, try to set it now
		if ((self.previousDistance == nil) && ([self.distances count] > 0)) {
			self.previousDistance = [self.distances objectAtIndex:0];
		}
		return self.previousDistance;
	}
	else {
		return [self.distances objectAtIndex:
				[self.pickerView selectedRowInComponent:STSDistanceComponent]];
	}
}

- (NSString *) getSelectedOrPreviousCourse {
    if ((self.courses == nil) || ([self.courses count] == 0)) {
        return nil;
    }
    
    // if there is no row currently selected, return the previous value
	if ([self.pickerView selectedRowInComponent:STSCourseComponent] < 0) {
		// if there  is no previous value, try to set it now
		if ((self.previousCourse == nil) && ([self.courses count] > 0)) {
			self.previousCourse = [self.courses objectAtIndex:0];
		}
		return self.previousCourse;
	}
	else {
		return [self.courses objectAtIndex:
				[self.pickerView selectedRowInComponent:STSCourseComponent]];
	}
}

- (NSUInteger) getRowWhichComponentShouldSelect: (NSUInteger) component {
	int newRow = 0;
	NSArray * arrayToSearch = nil;
	NSString * stringToMatch = nil;
	switch (component) {
		case STSDistanceComponent:
			arrayToSearch = self.distances;
			stringToMatch = self.previousDistance;
			break;
		case STSStrokeComponent:
			arrayToSearch = self.strokes;
			stringToMatch = self.previousStroke;
			break;
		case STSCourseComponent:
			arrayToSearch = self.courses;
			stringToMatch = self.previousCourse;
			break;
		default:
			break;
	}
	// only change the default (0) if the previous value 
	// gives a good match in the existing set of values
    if (stringToMatch != nil) {
        for (NSString * nextVal in arrayToSearch) {
            NSComparisonResult result = [nextVal compare: stringToMatch];
            if (result == NSOrderedSame) {
                newRow = [arrayToSearch indexOfObject:nextVal];
                break;
            }
        }
    }
    return newRow;
}

- (void) reloadStrokeComponent {
	NSManagedObject * currentSwimmer = [appDelegate getHomeScreenSwimmer];
	NSString * currentGender = [currentSwimmer valueForKey:@"swimmerGender"];
	NSString * currentAgeGroup = [currentSwimmer valueForKey:@"swimmerAgeGroup"];
	self.strokes = [[appDelegate timeStandardDataAccess] getAllStrokeNamesForStandardName:[appDelegate getHomeScreenTimeStandard]
																				andGender:currentGender
																		  andAgeGroupName:currentAgeGroup];
	[self.pickerView reloadComponent: STSStrokeComponent];
	if ([self.strokes count] > 0) {
		NSUInteger newRow = [self getRowWhichComponentShouldSelect:STSStrokeComponent];
		// very important to have new row selected without animation so that the time
		// label will update properly
		[self.pickerView selectRow:newRow inComponent:STSStrokeComponent animated:NO];
		self.previousStroke = [self.strokes objectAtIndex:newRow];
	}
}

- (void) reloadDistanceComponent {
	NSManagedObject * currentSwimmer = [appDelegate getHomeScreenSwimmer];
	NSString * currentGender = [currentSwimmer valueForKey:@"swimmerGender"];
	NSString * currentAgeGroup = [currentSwimmer valueForKey:@"swimmerAgeGroup"];
	// avoid index out of range exception if no row is currently selected in the picker
	NSString * selectedFormat = [self getSelectedOrPreviousCourse];
	NSString * selectedStroke = [self getSelectedOrPreviousStroke];
	
	self.distances = [[appDelegate timeStandardDataAccess]  getDistancesForStandardName:[appDelegate getHomeScreenTimeStandard]
																			  andGender:currentGender
																		andAgeGroupName:currentAgeGroup
																		  andStrokeName:selectedStroke
																			  andFormat:selectedFormat];
	[self.pickerView reloadComponent:STSDistanceComponent];
	if ([self.distances count] > 0) {
		NSUInteger newRow = [self getRowWhichComponentShouldSelect: STSDistanceComponent];
		// very important to have new row selected without animation so that the time
		// label will update properly
		[self.pickerView selectRow:newRow inComponent:STSDistanceComponent animated:NO];
		self.previousDistance = [self.distances objectAtIndex:newRow];
	}
}

- (void) reloadCourseComponent {
	NSManagedObject * currentSwimmer = [appDelegate getHomeScreenSwimmer];
	NSString * currentGender = [currentSwimmer valueForKey:@"swimmerGender"];
	NSString * currentAgeGroup = [currentSwimmer valueForKey:@"swimmerAgeGroup"];
	
	// avoid index out of range exception if no row is currently selected in the picker
	NSString * selectedDistance = [self getSelectedOrPreviousDistance];
	NSString * selectedStroke = [self getSelectedOrPreviousStroke];
	
	self.courses = [[appDelegate timeStandardDataAccess]					getFormatForStandardName:[appDelegate getHomeScreenTimeStandard]
																			andGender:currentGender
																	  andAgeGroupName:currentAgeGroup
																		  andDistance:selectedDistance
																		andStrokeName:selectedStroke];
	[self.pickerView reloadComponent:STSCourseComponent];
	if ([self.courses count] > 0) {
		NSUInteger newRow = [self getRowWhichComponentShouldSelect:STSCourseComponent];
		// very important to have new row selected without animation so that the time
		// label will update properly
		[self.pickerView selectRow:newRow inComponent:STSCourseComponent animated:NO];
		self.previousCourse = [self.courses objectAtIndex:newRow];
	}
}

- (void) reloadPicker {
	NSManagedObject * currentSwimmer = [appDelegate getHomeScreenSwimmer];
	if (([currentSwimmer valueForKey:@"swimmerGender"] != nil) && ([currentSwimmer valueForKey:@"swimmerAgeGroup"] != nil)) 
	{
		[self reloadStrokeComponent];
		[self reloadDistanceComponent];
		[self reloadCourseComponent];
		return;
	}
	else {
		self.strokes = nil;
		self.distances = nil;
		self.courses = nil;
		[self.pickerView reloadComponent:STSStrokeComponent];
		[self.pickerView reloadComponent:STSDistanceComponent];
		[self.pickerView reloadComponent:STSCourseComponent];
	}
}

- (void) updateTimeLabel {
	NSString * timeStr = nil;
	NSString * ageGroup = nil;
	NSString * timeStandardStr = [appDelegate getHomeScreenTimeStandard];
	if ((self.distances != nil) && ([self.distances count] != 0) &&
		(self.strokes != nil) && ([self.strokes count] != 0) &&
		(self.courses != nil) && ([self.courses count] != 0)) {
		NSManagedObject * tempCurrentSwimmer = [appDelegate getHomeScreenSwimmer];
		NSString * gender = [tempCurrentSwimmer valueForKey:@"swimmerGender"];
		ageGroup = [tempCurrentSwimmer valueForKey:@"swimmerAgeGroup"];
		NSUInteger distanceRow = [self.pickerView selectedRowInComponent:STSDistanceComponent];
		NSString * distanceString = [self.distances objectAtIndex:distanceRow];
		NSUInteger strokeRow = [self.pickerView selectedRowInComponent:STSStrokeComponent];
		NSString * strokeString = [self.strokes objectAtIndex:strokeRow];
		NSUInteger formatRow = [self.pickerView selectedRowInComponent:STSCourseComponent];
		NSString * formatString = [self.courses objectAtIndex:formatRow];
		timeStr = [[appDelegate timeStandardDataAccess]				   getTimeForStandardName:timeStandardStr
																		   andGender:gender
																	 andAgeGroupName:ageGroup
																		 andDistance:distanceString
																	   andStrokeName:strokeString
																		   andFormat:formatString];
	}
	if (timeStandardStr == nil) {
		timeStr = @"Please select a time standard.";
	}
	else if (ageGroup == nil) {
		timeStr = [NSString stringWithFormat:@"Please select an age group for %@.", timeStandardStr];
	}
	else if (timeStr == nil) {
		timeStr = [NSString stringWithFormat:@"There is no age group %@ for %@.", ageGroup, timeStandardStr];
	}
	self.label.text = timeStr;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
	if ([self homeScreenValuesHaveChanged] == YES) {
		[tableView reloadData];
		[self reloadPicker];
		[self updateTimeLabel];
	}
    [super viewWillAppear:animated];
}

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
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.controllers count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableViewParam cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *StandardCellIdentifier = @"StandardCell";
	static NSString *SwimmerCellIdentifier = @"SwimmerCell";
	NSUInteger row = [indexPath row];
	UITableViewCell *cell = nil;
	
	switch (row) {
		case STSStandardRow:
			cell = [tableViewParam dequeueReusableCellWithIdentifier:StandardCellIdentifier];
			if (cell == nil) {
				[[NSBundle mainBundle] loadNibNamed:@"StandardTableCell" 
											  owner:self 
											options:nil];
				cell = nibLoadedStandardCell;
			}
			// Configure the cell.
			NSString * timeStandardName = [appDelegate getHomeScreenTimeStandard];
			UILabel * standardNameLabel = (UILabel *) [cell viewWithTag:1];
			standardNameLabel.text = timeStandardName;
			self.previousTimeStandard = timeStandardName;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case STSSwimmerRow:
			cell = [tableViewParam dequeueReusableCellWithIdentifier:SwimmerCellIdentifier];
			if (cell == nil) {
				
				[[NSBundle mainBundle] loadNibNamed:@"SwimmerTableCell" 
											  owner:self 
											options:nil];
				cell = nibLoadedSwimmerCell;
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			// Configure the cell.
			NSManagedObject * swimmer = [appDelegate getHomeScreenSwimmer];
			
			UILabel * swimmerNameLabel = (UILabel *) [cell viewWithTag:1];
			swimmerNameLabel.text = [swimmer valueForKey:@"swimmerName"];
			
			UILabel * swimmerDescriptionLabel = (UILabel *) [cell viewWithTag:2];
			NSMutableString * swimmerDescription = [NSMutableString stringWithCapacity:20];
			NSString * swimmerAgeGroup = [swimmer valueForKey:@"swimmerAgeGroup"];
			self.previousAgeGroup = swimmerAgeGroup;
			swimmerAgeGroup = (swimmerAgeGroup == nil) ? @"(re)select age group" : swimmerAgeGroup;
			[swimmerDescription appendString:swimmerAgeGroup];
			[swimmerDescription appendString:@" "];
			
			NSString * swimmerGender = [swimmer valueForKey:@"swimmerGender"];
			self.previousGender = swimmerGender;
			swimmerGender = (swimmerGender == nil) ? @"select gender" : swimmerGender;
			[swimmerDescription appendString:swimmerGender];
			swimmerDescriptionLabel.text = swimmerDescription;
			
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
			break;
		default:
			break;
	}
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
 }
 */


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableViewParam didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    UITableViewController *detailViewController = [self.controllers 
                                                   objectAtIndex:row];
	
	// ...
	// Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController 
                                         animated:YES];
    [tableViewParam deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Picker Data Source Methods

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 3;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView 
 numberOfRowsInComponent:(NSInteger)component {
	switch (component) {
		case STSDistanceComponent:
			return [self.distances count];
			break;
		case STSStrokeComponent:
			return [self.strokes count];
			break;
		case STSCourseComponent:
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
		case STSStrokeComponent:
			return ([self.strokes count] > 0) ? [self.strokes objectAtIndex:row] : @"";
			break;
		case STSDistanceComponent:
			return ([self.distances count] > 0) ? [self.distances objectAtIndex:row] : @"";
			break;
		case STSCourseComponent:
			return ([self.courses count] > 0) ? [self.courses objectAtIndex:row] : @"";
			break;
		default:
			return @"";
			break;
	}
}


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row 
		inComponent:(NSInteger)component {
	switch (component) {
		case STSStrokeComponent:
			[self reloadDistanceComponent];
			[self reloadCourseComponent];
			if ([self.strokes count] > 0) {
				self.previousStroke = [self.strokes objectAtIndex: row];
			}
			break;
		case STSDistanceComponent:
			[self reloadCourseComponent];
			if ([self.distances count] > 0) {
				self.previousDistance = [self.distances objectAtIndex: row];
			}
			break;
		case STSCourseComponent:
			[self reloadDistanceComponent];
			if ([self.courses count] > 0) {
				self.previousCourse = [self.courses objectAtIndex:row];
			}
			break;
		default:
			break;
	}
	[self updateTimeLabel];
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
	self.pickerView = nil;
	self.label = nil;
	self.tableView = nil;
    self.nibLoadedSwimmerCell = nil;
    self.nibLoadedStandardCell = nil;
}


- (void)dealloc {
	[controllers release];
    [pickerView release];
	[label release];
	[tableView release];
    [nibLoadedSwimmerCell release];
    [nibLoadedStandardCell release];
	[timeStandardController release];
	[swimmerController release];
	[distances release];
	[courses release];
	[strokes release];
	[previousStroke release];
	[previousDistance release];
	[previousCourse release];
    [previousTimeStandard release];
    [previousAgeGroup release];
    [previousGender release];
    
    [super dealloc];
}


@end

