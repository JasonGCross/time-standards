//
//  RootViewController.m
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "STSRootViewController.h"
#import "STSSwimmerDataAccess.h"
#import "STSTimeStandardDataAccess.h"
#import "STSTimeStandardController.h"
#import "STSSwimmerController.h"
#import "STSTimeStandardHomeScreenTableCell.h"
#import "STSSwimmerHomeScreenTableViewCell.h"
#import "STSSwimmerHomeScreenTableViewCell+Binding.h"
#import "STSTimeStandardHomeScreenTableCell+Binding.h"





typedef NS_ENUM(NSUInteger, STSHomeScreenRows) {
    STSHomeScreenRowTimeStandards,
    STSHomeScreenRowSwimmer,
    STSHomeScreenTotalRows
};

typedef NS_ENUM(NSUInteger, STSPickerComponents) {
    STSPickerComponentStroke,
    STSPickerComponentDistance,
    //STSPickerComponentsCourse,
    STSPickerTotalComponents
};


@interface STSRootViewController ()
@property (nonatomic, strong) STSTimeStandardController	* timeStandardController;
@property (nonatomic, strong) STSSwimmerController      * swimmerController;
@property (nonatomic, strong) NSMutableDictionary       * previousPickerValues;
@property (nonatomic, strong) NSDictionary              * keyIds;
@property (nonatomic, strong) IBOutlet UISegmentedControl * courseSegmentedControl;
@property (nonatomic, weak) IBOutlet UILabel            * timeLabel;
@end


@implementation STSRootViewController

#pragma mark -  View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"PNS Time Standards";
	
    // we need to know when the critical home screen values change, so
    // that we can change the picker appropriately
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleHomeScreenValueChange)
                                                 name:STSHomeScreenValuesChangedKey
                                               object: nil];
	
	// picker columns
	self.strokes = [[NSArray alloc] init];
	self.courses = [[NSArray alloc] init];
	self.distances = [[NSArray alloc] init];
}


// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
}

#pragma mark - Private helper methods

- (BOOL) homeScreenValuesHaveChanged {
	if ((self.previousTimeStandard == nil) || (self.previousAgeGroup == nil) || (self.previousGender == nil)) {
		return YES;
	}
	NSString * currentStandard = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenTimeStandard];
	NSManagedObject * currentSwimmer = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenSwimmer];
	NSString * currentGender = [currentSwimmer valueForKey:@"swimmerGender"];
	NSString * currentAgeGroup = [currentSwimmer valueForKey:@"swimmerAgeGroup"];
	
	if([self.previousTimeStandard isEqualToString: currentStandard] && 
			[self.previousAgeGroup isEqualToString: currentAgeGroup] && 
			[self.previousGender isEqualToString: currentGender]) {
		return NO;
	}
	return YES;
}

- (void) updateCourseSegmentedControlSegments {
    static NSArray * defaultCourses = nil;
    if (defaultCourses == nil) {
        defaultCourses = @[@"scy", @"lcm"];
    }
    
    NSArray * coursesToSet = [NSArray sts_isEmpty:self.courses] ? defaultCourses : self.courses;
    [self.courseSegmentedControl removeAllSegments];
    for (int i=0; i < [coursesToSet count]; i++) {
        // very important to have new segments created without animation so that the time
		// timeLabel will update properly
        [self.courseSegmentedControl insertSegmentWithTitle:coursesToSet[i] atIndex:i animated:NO];
        if ([self.previousCourse isEqualToString:coursesToSet[i]]) {
            [self.courseSegmentedControl setSelectedSegmentIndex:i];
        }
    }

}

- (NSString *) getSelectedOrPreviousStroke {
    if ((nil == self.strokes) || ([self.strokes count] == 0)) {
        return nil;
    }
    
	// if there is no row currently selected, return the previous value
	if ([self.pickerView selectedRowInComponent:STSPickerComponentStroke] < 0) {
		// if there is no previous value, try to set it now
		if ((self.previousStroke == nil) && ([self.strokes count] > 0)) {
			self.previousStroke = (self.strokes)[0];
		}
		return self.previousStroke;
	}
	else {
		return (self.strokes)[[self.pickerView selectedRowInComponent:STSPickerComponentStroke]];
	}
}

- (NSString *) getSelectedOrPreviousDistance {
    if ((nil == self.distances) || ([self.distances count] == 0)) {
        return nil;
    }
	// if there is no row currently selected, return the previous value
	if ([self.pickerView selectedRowInComponent:STSPickerComponentDistance] < 0) {
		// if there  is no previous value, try to set it now
		if ((self.previousDistance == nil) && ([self.distances count] > 0)) {
			self.previousDistance = (self.distances)[0];
		}
		return self.previousDistance;
	}
	else {
		return (self.distances)[[self.pickerView selectedRowInComponent:STSPickerComponentDistance]];
	}
}

- (NSString *) getSelectedOrPreviousCourse {
    if ((self.courses == nil) || ([self.courses count] == 0)) {
        return nil;
    }
    
    // if there is no segment currently selected, return the previous value
    if ([self.courseSegmentedControl selectedSegmentIndex] < 0) {
        // if there  is no previous value, try to set it now
		if ((self.previousCourse == nil) && ([self.courses count] > 0)) {
			self.previousCourse = (self.courses)[0];
		}
		return self.previousCourse;
    }
	else {
		return (self.courses)[[self.courseSegmentedControl selectedSegmentIndex]];
	}
}

- (NSUInteger) getRowWhichComponentShouldSelect: (NSUInteger) component {
	NSUInteger newRow = 0;
	NSArray * arrayToSearch = nil;
	NSString * stringToMatch = nil;
	switch (component) {
		case STSPickerComponentDistance:
			arrayToSearch = self.distances;
			stringToMatch = self.previousDistance;
			break;
		case STSPickerComponentStroke:
			arrayToSearch = self.strokes;
			stringToMatch = self.previousStroke;
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
	NSManagedObject * currentSwimmer = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenSwimmer];
	NSString * currentGender = [currentSwimmer valueForKey:@"swimmerGender"];
	NSString * currentAgeGroup = [currentSwimmer valueForKey:@"swimmerAgeGroup"];
	self.strokes = [[STSTimeStandardDataAccess sharedDataAccess] getAllStrokeNamesForStandardName:[[STSSwimmerDataAccess sharedDataAccess] getHomeScreenTimeStandard]
																				andGender:currentGender
																		  andAgeGroupName:currentAgeGroup];
	[self.pickerView reloadComponent: STSPickerComponentStroke];
	if ([self.strokes count] > 0) {
		NSUInteger newRow = [self getRowWhichComponentShouldSelect:STSPickerComponentStroke];
		// very important to have new row selected without animation so that the time
		// label will update properly
		[self.pickerView selectRow:newRow inComponent:STSPickerComponentStroke animated:NO];
		self.previousStroke = (self.strokes)[newRow];
				}
}

- (void) reloadCourseSegmentedControl {
    /*
     5) update the courses array and the switch which uses it
     6) select the "previousCourse" for the switch, or the first value
         if the previousCourse does not match any course in the course array
     */
    STSSwimmerDataAccess* sharedSwimmerDataAccess = [STSSwimmerDataAccess sharedDataAccess];
    NSManagedObject * currentSwimmer = [sharedSwimmerDataAccess getHomeScreenSwimmer];
	NSString * currentGender = [currentSwimmer valueForKey:@"swimmerGender"];
	NSString * currentAgeGroup = [currentSwimmer valueForKey:@"swimmerAgeGroup"];
    
	NSString * selectedStroke = [self getSelectedOrPreviousStroke];
    NSString * selectedDistance = nil;
	
    STSTimeStandardDataAccess* sharedTimeStandardDataAccess = [STSTimeStandardDataAccess sharedDataAccess];
    NSString * timeStandardName = [sharedSwimmerDataAccess getHomeScreenTimeStandard];
    
    NSArray * courses = [sharedTimeStandardDataAccess getFormatForStandardName:timeStandardName
                                                                     andGender:currentGender
                                                               andAgeGroupName:currentAgeGroup
                                                                   andDistance:selectedDistance
                                                                 andStrokeName:selectedStroke];
    
    self.courses = courses;
    [self updateCourseSegmentedControlSegments];
    
//    if ([self.courses count] > 0) {
//		NSUInteger newRow = [self getRowWhichComponentShouldSelect:STSPickerComponentsCourse];
//        [self.courseSegmentedControl setSelectedSegmentIndex:newRow];
//		self.previousCourse = (self.courses)[newRow];
//	}
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
    NSString * standardName = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenTimeStandard];
	NSManagedObject * currentSwimmer = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenSwimmer];
	NSString * currentGender = [currentSwimmer valueForKey:@"swimmerGender"];
	NSString * currentAgeGroup = [currentSwimmer valueForKey:@"swimmerAgeGroup"];
	// avoid index out of range exception if no row is currently selected in the picker
	NSString * selectedFormat = [self getSelectedOrPreviousCourse];
	NSString * selectedStroke = [self getSelectedOrPreviousStroke];
	
    NSDictionary * outDictionary = nil;
	
	self.distances = [[STSTimeStandardDataAccess sharedDataAccess] getDistancesForStandardName:standardName
																			andGender:currentGender
																	  andAgeGroupName:currentAgeGroup
																		  andStrokeName:selectedStroke
																			  andFormat:selectedFormat 
                                                                  putKeysIntoDictionary:&outDictionary];
    self.keyIds = outDictionary;
    
	[self.pickerView reloadComponent:STSPickerComponentDistance];
	if ([self.distances count] > 0) {
		NSUInteger newRow = [self getRowWhichComponentShouldSelect: STSPickerComponentDistance];
		// very important to have new row selected without animation so that the time
		// timeLabel will update properly
		[self.pickerView selectRow:newRow inComponent:STSPickerComponentDistance animated:NO];
		self.previousDistance = (self.distances)[newRow];
	}
}

- (void) reloadPicker {
	NSManagedObject * currentSwimmer = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenSwimmer];
	if (([currentSwimmer valueForKey:@"swimmerGender"] != nil) && ([currentSwimmer valueForKey:@"swimmerAgeGroup"] != nil)) 
	{
		[self reloadStrokeComponent];
        [self reloadCourseSegmentedControl];
		[self reloadDistanceComponent];
		return;
	}
	else
    {
		self.strokes = nil;
		self.courses = nil;
		self.distances = nil;
	
        // 1 - strokes
        [self.pickerView reloadComponent:STSPickerComponentStroke];
			
        // 2 - courses
        [self updateCourseSegmentedControlSegments];
        
        // 3 - distances
        [self.pickerView reloadComponent:STSPickerComponentDistance];
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
    NSManagedObject * currentSwimmer = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenSwimmer];
	NSString * ageGroup = [currentSwimmer valueForKey:@"swimmerAgeGroup"];

	NSString * timeStr = nil;
    NSString * timeStandardStr = [[STSSwimmerDataAccess sharedDataAccess] getHomeScreenTimeStandard];
	if ((self.keyIds != nil) && ([self.keyIds count] != 0)) 
        {
        NSUInteger distanceRow = [self.pickerView selectedRowInComponent:STSPickerComponentDistance];
        NSString * distanceString = (self.distances)[distanceRow];
        NSString * keyId = (self.keyIds)[distanceString];
        
        timeStr = [[STSTimeStandardDataAccess sharedDataAccess] getTimeForKeyId:keyId];
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
	return STSPickerTotalComponents;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView 
 numberOfRowsInComponent:(NSInteger)component {
	switch (component) {
		case STSPickerComponentDistance:
			return [self.distances count];
			break;
		case STSPickerComponentStroke:
			return [self.strokes count];
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
		case STSPickerComponentStroke:
			return ([self.strokes count] > 0) ? (self.strokes)[row] : @"";
			break;
		case STSPickerComponentDistance:
			return ([self.distances count] > 0) ? (self.distances)[row] : @"";
			break;
		default:
			return @"";
			break;
	}
}


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row 
		inComponent:(NSInteger)component {
	switch (component) {
		case STSPickerComponentStroke:
		/*
                 13) Any time the user changes the switch or the stroke, go back to step 7
                */
			[self reloadDistanceComponent];
			[self updateTimeLabel];
			if ([self.strokes count] > 0) {
				self.previousStroke = (self.strokes)[row];
			}
			break;
		case STSPickerComponentDistance:
		/*
                14) Any time the user changes the distance, go back to step 10
                */
			[self updateTimeLabel];
			if ([self.distances count] > 0) {
				self.previousDistance = (self.distances)[row];
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
    NSUInteger selectedIndex = [self.courseSegmentedControl selectedSegmentIndex];
			[self reloadDistanceComponent];
			[self updateTimeLabel];
			if ([self.courses count] > 0) {
				self.previousCourse = (self.courses)[selectedIndex];
			}
}

#pragma mark - Segues.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueId = [segue identifier];
    
    if([segueId isEqualToString:kTimeStandardSegueIdentifier ]){

    }
    else if ([segueId isEqualToString:kSwimmerDetailSegueIdentifier]) {

    }
}





@end

