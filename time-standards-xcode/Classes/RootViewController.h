//
//  RootViewController.h
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


@interface RootViewController : UIViewController 
<NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, 
UIPickerViewDelegate, UIPickerViewDataSource> {
	NSArray			* controllers;
    UITableView		* tableView;
	UIPickerView	* pickerView;
	UILabel			* label;
	UITableViewCell * nibLoadedStandardCell;
	UITableViewCell * nibLoadedSwimmerCell;
	
	NSArray			* strokes;
	NSArray			* distances;
	NSArray			* courses;
	
	NSString		* previousStroke;
	NSString		* previousDistance;
	NSString		* previousCourse;
	
	NSString		* previousTimeStandard;
	NSString		* previousAgeGroup;
	NSString		* previousGender;
	
	TimeStandardController				* timeStandardController;
	SwimmerController					* swimmerController;
    SwimmingTimeStandardsAppDelegate	* appDelegate;
}

@property (nonatomic, retain) NSArray		* controllers;
@property (nonatomic, retain) IBOutlet		UIPickerView	* pickerView;
@property (nonatomic, retain) IBOutlet		UILabel			* label;
@property (nonatomic, retain) IBOutlet		UITableView		* tableView;
@property (nonatomic, retain) IBOutlet		UITableViewCell * nibLoadedStandardCell;
@property (nonatomic, retain) IBOutlet		UITableViewCell * nibLoadedSwimmerCell;


@property (nonatomic, retain) NSArray		* strokes;
@property (nonatomic, retain) NSArray		* distances;
@property (nonatomic, retain) NSArray		* courses;

@property (nonatomic, retain) NSString		* previousStroke;
@property (nonatomic, retain) NSString		* previousDistance;
@property (nonatomic, retain) NSString		* previousCourse;

@property (nonatomic, retain) NSString		* previousTimeStandard;
@property (nonatomic, retain) NSString		* previousAgeGroup;
@property (nonatomic, retain) NSString		* previousGender;

@end
