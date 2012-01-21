//
//  HomeScreenViewController.m
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

/*
 Here is the general strategy for using the data base of swim times
 in cooperation with the UI Elements.
 Note that calls to the DB are expensive and should be minimized
 1) upon view will appear, check to see if the critical home screen values 
    have changed
        The critical home screen values are defined as:
        a) timeStandard
        b) age
        c) gender
 2) if home screen values have changed, make a call to the DB and get
        a) a list of all the strokes (regardless of distance or course)
        b) a list of all the courses (regardless of distance or stroke)
 3) populate the strokes array
 4) select the row in the stroke component of the picker using the 
        "previousStroke", or the first row if the last used stroke doesn't 
        match any strokes in the strokes array
 5) update the courses array and the switch which uses it
 6) select the "previousCourse" for the switch, or the first value
        if the previousCourse does not match any course in the course array

 7) now we have 2/3 things needed to produce a time. The last thing we
        need is an array of distances. Make a call to the DB, passing in
        the selected stroke and the selected course.
 8) populate the distances array. Also save the table's keys in a dictionary with the distances.
 9) Select the distance row in the distance component of the picker using the
        "previousDistance", or the first row if the last used distance
        doesn't match any distances in the distance array
 10) Now we have 3/3 things needed to find out the time. Make a final
        call to the DB to get the time matching the {stroke,course,distance}
        tuple selected. A shortcut is to just use the keyID for this tuple,
        which is stored in the keyID dictionary.
 11) Update the display of the time label
 12) Any time the critical homeScreenValues have changed, go back to step 2 
 13) Any time the user changes the switch or the stroke, go back to step 7
 14) Any time the user changes the distance, go back to step 10
 */


#import "HomeScreenViewController.h"
#import "SwimmingTimeStandardsAppDelegate.h"
#import "TimeStandardDataAccess.h"


@interface HomeScreenViewController(HomeScreenViewControllerPrivate)
- (BOOL) homeScreenValuesHaveChanged;
- (NSString *) getSelectedOrPreviousStroke;
- (NSString *) getSelectedOrPreviousDistance;
- (NSString *) getSelectedOrPreviousCourse;
- (NSUInteger) getRowWhichComponentShouldSelect: (NSUInteger) component;
- (void) reloadStrokeComponent;
- (void) reloadDistanceComponent;
- (void) reloadCourseComponent;
- (void) reloadPicker;
- (void) updateTimeLabel;
@end


@implementation HomeScreenViewController

@synthesize pickerView, timeLabel;
@synthesize nibLoadedStandardCell, nibLoadedSwimmerCell;
@synthesize segmentedControl;
@synthesize strokes, courses, distances, keyIds;
@synthesize previousStroke, previousDistance, previousCourse;
@synthesize previousTimeStandard, previousAgeGroup, previousGender;


#pragma mark - View lifecycle

- (void) viewDidLoad {
    self.title = @"PNS Time Standards";
    appDelegate = (SwimmingTimeStandardsAppDelegate *)[[UIApplication sharedApplication]
                                                       delegate];
    
    // we need to know when the critical home screen values change, so
    // that we can change the picker appropriately
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleHomeScreenValueChange) 
                                                 name:STSHomeScreenValuesChangedKey
                                               object: nil];

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

- (void)viewWillAppear:(BOOL)animated {
    /*
     1) upon view will appear, check to see if the critical home screen values have changed
        The critical home screen values are defined as:
             a) timeStandard
             b) age
             c) gender
     */
	if ([self homeScreenValuesHaveChanged] == YES) {
		[self handleHomeScreenValueChange];
	}
    [super viewWillAppear:animated];
}

#pragma mark - Private helper methods

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
    
    // if there is no segment currently selected, return the previous value
    if ([self.segmentedControl selectedSegmentIndex] < 0) {
        // if there  is no previous value, try to set it now
		if ((self.previousCourse == nil) && ([self.courses count] > 0)) {
			self.previousCourse = [self.courses objectAtIndex:0];
		}
		return self.previousCourse;
    }
	else {
		return [self.courses objectAtIndex:
				[self.segmentedControl selectedSegmentIndex]];
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
    /*
     3) populate the strokes array
     4) select the row in the stroke component of the picker using the 
         "previousStroke", or the first row if the last used stroke doesn't 
         match any strokes in the strokes array
     */
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
		// timeLabel will update properly
		[self.pickerView selectRow:newRow inComponent:STSStrokeComponent animated:NO];
		self.previousStroke = [self.strokes objectAtIndex:newRow];
	}
}

- (void) reloadCourseSegmentedControl {
    /*
     5) update the courses array and the switch which uses it
     6) select the "previousCourse" for the switch, or the first value
         if the previousCourse does not match any course in the course array
     */
    NSManagedObject * currentSwimmer = [appDelegate getHomeScreenSwimmer];
	NSString * currentGender = [currentSwimmer valueForKey:@"swimmerGender"];
	NSString * currentAgeGroup = [currentSwimmer valueForKey:@"swimmerAgeGroup"];
    
    NSString * selectedStroke = [self getSelectedOrPreviousStroke];
    NSString * selectedDistance = nil;
    
    self.courses = [[appDelegate timeStandardDataAccess]					getFormatForStandardName:[appDelegate getHomeScreenTimeStandard]
																			andGender:currentGender
																	  andAgeGroupName:currentAgeGroup
																		  andDistance:selectedDistance
																		andStrokeName:selectedStroke];
    CGRect segmentedRectangle = self.segmentedControl.frame;
    [self.segmentedControl removeAllSegments];
    for (int i=0; i < [self.courses count]; i++) {
        // very important to have new segments created without animation so that the time
		// timeLabel will update properly
        [self.segmentedControl insertSegmentWithTitle:[self.courses objectAtIndex:i] atIndex:i animated:NO];
        self.segmentedControl.frame = segmentedRectangle;
    }
    
    
    if ([self.courses count] > 0) {
		NSUInteger newRow = [self getRowWhichComponentShouldSelect:STSCourseComponent];
        [self.segmentedControl setSelectedSegmentIndex:newRow];
		self.previousCourse = [self.courses objectAtIndex:newRow];
	}
}

- (void) reloadDistanceComponent {
    /*
     7) Now we have 2/3 things needed to produce a time. The last thing we
         need is an array of distances. Make a call to the DB, passing in
         the selected stroke and the selected course.
     8) populate the distances array. Also save the table's keys in a dictionary with the distances.
     9) Select the distance row in the distance component of the picker using the
         "previousDistance", or the first row if the last used distance
         doesn't match any distances in the distance array
     */
	NSManagedObject * currentSwimmer = [appDelegate getHomeScreenSwimmer];
	NSString * currentGender = [currentSwimmer valueForKey:@"swimmerGender"];
	NSString * currentAgeGroup = [currentSwimmer valueForKey:@"swimmerAgeGroup"];
	// avoid index out of range exception if no row is currently selected in the picker
	NSString * selectedFormat = [self getSelectedOrPreviousCourse];
	NSString * selectedStroke = [self getSelectedOrPreviousStroke];
    
    NSDictionary * outDictionary = nil;
	
	self.distances = [[appDelegate timeStandardDataAccess]  getDistancesForStandardName:[appDelegate getHomeScreenTimeStandard]
																			  andGender:currentGender
																		andAgeGroupName:currentAgeGroup
																		  andStrokeName:selectedStroke
																			  andFormat:selectedFormat 
                                                                  putKeysIntoDictionary:&outDictionary];
    self.keyIds = outDictionary;
    
	[self.pickerView reloadComponent:STSDistanceComponent];
	if ([self.distances count] > 0) {
		NSUInteger newRow = [self getRowWhichComponentShouldSelect: STSDistanceComponent];
		// very important to have new row selected without animation so that the time
		// timeLabel will update properly
		[self.pickerView selectRow:newRow inComponent:STSDistanceComponent animated:NO];
		self.previousDistance = [self.distances objectAtIndex:newRow];
	}
}



- (void) reloadPicker {
	NSManagedObject * currentSwimmer = [appDelegate getHomeScreenSwimmer];
	if (([currentSwimmer valueForKey:@"swimmerGender"] != nil) && ([currentSwimmer valueForKey:@"swimmerAgeGroup"] != nil)) 
	{
		[self reloadStrokeComponent];
        [self reloadCourseSegmentedControl];
		[self reloadDistanceComponent];
		return;
	}
	else {
		self.strokes = nil;
        self.courses = nil;
		self.distances = nil;
        
        // 1 - strokes
        [self.pickerView reloadComponent:STSStrokeComponent];
        
        // 2 - courses
        static NSArray * defaultCourses = nil;
        if (defaultCourses == nil) {
            defaultCourses = [[NSArray arrayWithObjects:@"scy", @"lcm", nil] retain];
        }
        self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:defaultCourses] autorelease];
        
        // 3 - distances
        [self.pickerView reloadComponent:STSDistanceComponent];
	}
}

- (void) updateTimeLabel {
    /*
     10) Now we have 3/3 things needed to find out the time. Make a final
             call to the DB to get the time matching the {stroke,course,distance}
             tuple selected. A shortcut is to just use the keyID for this tuple,
             which is stored in the keyID dictionary.
     11) Update the display of the time label
     */
	NSString * timeStr = nil;
	NSString * ageGroup = nil;
	NSString * timeStandardStr = [appDelegate getHomeScreenTimeStandard];
	if ((self.distances != nil) && ([self.distances count] != 0) &&
		(self.strokes != nil) && ([self.strokes count] != 0) &&
		(self.courses != nil) && ([self.courses count] != 0)) 
    {
        
        // core values
		NSManagedObject * tempCurrentSwimmer = [appDelegate getHomeScreenSwimmer];
		NSString * gender = [tempCurrentSwimmer valueForKey:@"swimmerGender"];
		ageGroup = [tempCurrentSwimmer valueForKey:@"swimmerAgeGroup"];
        
        // key ID
        NSUInteger distanceRow = [self.pickerView selectedRowInComponent:STSDistanceComponent];
        NSString * distanceString = [self.distances objectAtIndex:distanceRow];
        
        NSString * keyId = [self.keyIds objectForKey:distanceString];
        
        timeStr = [[appDelegate timeStandardDataAccess] getTimeForStandardName:timeStandardStr
                                                                     andGender:gender
                                                               andAgeGroupName:ageGroup
                                                                      andKeyId:keyId];


	}
	if (timeStandardStr == nil) {
		timeStr = @"select time standard.";
	}
	else if (ageGroup == nil) {
		timeStr = [NSString stringWithFormat:@"(re) select age group"];
	}
	else if (timeStr == nil) {
		timeStr = [NSString stringWithFormat:@"No matching age group"];
	}
	self.timeLabel.text = timeStr;
    //[self.timeLabel set
}

#pragma mark - public methods

- (void) handleHomeScreenValueChange; {
    /*
     2) if home screen values have changed, make a call to the DB and get
         a) a list of all the strokes (regardless of distance or course)
         b) a list of all the courses (regardless of distance or stroke)
     
     12) Any time the critical homeScreenValues have changed, go back to step 2 
     */
    [self reloadPicker];
    [self updateTimeLabel];
}

#pragma mark - Picker Data Source Methods

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
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
		default:
			return 0;
			break;
	}
	
}

#pragma mark - Picker Delegate Methods

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
		default:
			return @"";
			break;
	}
}


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row 
		inComponent:(NSInteger)component {
	switch (component) {
		case STSStrokeComponent:
            /*
             13) Any time the user changes the switch or the stroke, go back to step 7
             */
			[self reloadDistanceComponent];
			[self updateTimeLabel];
			if ([self.strokes count] > 0) {
				self.previousStroke = [self.strokes objectAtIndex: row];
			}
			break;
		case STSDistanceComponent:
            /*
              14) Any time the user changes the distance, go back to step 10
             */
			[self updateTimeLabel];
			if ([self.distances count] > 0) {
				self.previousDistance = [self.distances objectAtIndex: row];
			}
			break;
		default:
			break;
	}
	[self updateTimeLabel];
}

#pragma mark - segmented control action

- (IBAction)segmentedControlDidChange:(id)sender; {
    /*
     13) Any time the user changes the switch or the stroke, go back to step 7
     */
    NSUInteger selectedIndex = [self.segmentedControl selectedSegmentIndex];
    [self reloadDistanceComponent];
    [self updateTimeLabel];
    if ([self.courses count] > 0) {
        self.previousCourse = [self.courses objectAtIndex:selectedIndex];
    }
}


#pragma mark - Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.pickerView = nil;
	self.timeLabel = nil;
    self.nibLoadedSwimmerCell = nil;
    self.nibLoadedStandardCell = nil;
    self.segmentedControl = nil;
}


- (void)dealloc {
    [pickerView release];
	[timeLabel release];
    [nibLoadedSwimmerCell release];
    [nibLoadedStandardCell release];
    [segmentedControl release];
	[distances release];
	[courses release];
	[strokes release];
    [keyIds release];
	[previousStroke release];
	[previousDistance release];
	[previousCourse release];
    [previousTimeStandard release];
    [previousAgeGroup release];
    [previousGender release];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}


@end

