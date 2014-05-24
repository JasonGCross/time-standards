//
//  RootViewController.h
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STSTimeStandardDataAccess;
@class STSTimeStandardController;
@class STSSwimmerController;
@class STSAppDelegate;

@class HomeScreenValues;

static NSString * const kSwimmerDetailSegueIdentifier = @"SwimmerDetailSegueue";
static NSString * const kTimeStandardSegueIdentifier = @"TimeStandardSegueue";
static NSString * const kSwimmerListSegueIdentifier = @"SwimmerListSegueue";


@interface STSRootViewController : UIViewController 
<NSFetchedResultsControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) IBOutlet		UIPickerView	* pickerView;
@property (nonatomic, strong) IBOutlet		UITableView		* tableView;


@property (nonatomic, strong) NSArray		* strokes;
@property (nonatomic, strong) NSArray		* distances;
@property (nonatomic, strong) NSArray		* courses;

@property (nonatomic, strong) NSString		* previousStroke;
@property (nonatomic, strong) NSString		* previousDistance;
@property (nonatomic, strong) NSString		* previousCourse;

@property (nonatomic, strong) NSString		* previousTimeStandard;
@property (nonatomic, strong) NSString		* previousAgeGroup;
@property (nonatomic, strong) NSString		* previousGender;

- (void) handleHomeScreenValueChange;

@end
