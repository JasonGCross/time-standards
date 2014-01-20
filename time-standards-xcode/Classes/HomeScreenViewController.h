//
//  HomeScreenViewController.h
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class TimeStandardDataAccess;
@class TimeStandardController;
@class SwimmerController;
@class SwimmingTimeStandardsAppDelegate;
@class HomeScreenValues;


@interface HomeScreenViewController : UIViewController 
<NSFetchedResultsControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {


	UIPickerView	* pickerView;
	UILabel			* timeLabel;
	UITableViewCell * nibLoadedStandardCell;
	UITableViewCell * nibLoadedSwimmerCell;
    UISegmentedControl * segmentedControl;
	
	NSArray			* strokes;
	NSArray			* distances;
	NSArray			* courses;
    NSDictionary    * keyIds;
	
	NSString		* previousStroke;
	NSString		* previousDistance;
	NSString		* previousCourse;
	
	NSString		* previousTimeStandard;
	NSString		* previousAgeGroup;
	NSString		* previousGender;
	
    SwimmingTimeStandardsAppDelegate	* appDelegate;
}


@property (nonatomic, strong) IBOutlet		UIPickerView	* pickerView;
@property (nonatomic, strong) IBOutlet		UILabel			* timeLabel;
@property (nonatomic, strong) IBOutlet		UITableViewCell * nibLoadedStandardCell;
@property (nonatomic, strong) IBOutlet		UITableViewCell * nibLoadedSwimmerCell;
@property (nonatomic, strong) IBOutlet      UISegmentedControl * segmentedControl;

@property (nonatomic, strong) NSArray		* strokes;
@property (nonatomic, strong) NSArray		* distances;
@property (nonatomic, strong) NSArray		* courses;
@property (nonatomic, strong) NSDictionary  * keyIds;

@property (nonatomic, strong) NSString		* previousStroke;
@property (nonatomic, strong) NSString		* previousDistance;
@property (nonatomic, strong) NSString		* previousCourse;

@property (nonatomic, strong) NSString		* previousTimeStandard;
@property (nonatomic, strong) NSString		* previousAgeGroup;
@property (nonatomic, strong) NSString		* previousGender;


- (void) handleHomeScreenValueChange;

- (IBAction)segmentedControlDidChange:(id)sender;

@end
