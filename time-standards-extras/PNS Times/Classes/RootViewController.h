
//
//  RootViewController.h
//  PNS Times
//
//  Created by JASON CROSS on 7/18/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNS_TimesGlobals.h"

@class TimeStandardController;
@class AgeController;
@class GenderController;
@class TimeStandardDataAccess;

@interface RootViewController : UIViewController
	<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
{
	NSArray			* controllers;
	UIPickerView	* pickerView;
	UILabel			* label;
	UITableView		* tableView;
	
@private
	TimeStandardController	* timeStandardController;
	AgeController			* ageController;
	GenderController		* genderController;
	TimeStandardDataAccess	* timeStandardDataAccess;
	
	NSArray			* strokes;
	NSArray			* distances;
	NSArray			* courses;
	
	NSString		* previousStroke;
	NSString		* previousDistance;
	NSString		* previousCourse;
}

@property (nonatomic, retain) NSArray		* controllers;
@property (nonatomic, retain) IBOutlet		UIPickerView	* pickerView;
@property (nonatomic, retain) IBOutlet		UILabel			* label;
@property (nonatomic, retain) IBOutlet		UITableView		* tableView;

@property (nonatomic, retain) NSArray		* strokes;
@property (nonatomic, retain) NSArray		* distances;
@property (nonatomic, retain) NSArray		* courses;

@property (nonatomic, retain) NSString		* previousStroke;
@property (nonatomic, retain) NSString		* previousDistance;
@property (nonatomic, retain) NSString		* previousCourse;

@property (nonatomic, retain) TimeStandardDataAccess		* timeStandardDataAccess;

- (void) applicationWillTerminate: (NSNotification *) notification;

@end
