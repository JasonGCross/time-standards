//
//  TopLevelSettingViewController.h
//  PNS Times
//
//  Created by JASON CROSS on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNS_TimesGlobals.h"

@class TimeStandardDataAccess;

@interface TopLevelSettingViewController : UITableViewController {
	NSString 		* settingName;
	NSString		* settingValue;
	NSArray 		* settingList;
	NSIndexPath		* lastIndexPath;
	TimeStandardDataAccess * timeStandardDataAccess;
}

@property (nonatomic, retain) NSString * settingName;
@property (nonatomic, retain) NSString * settingValue;
@property (nonatomic, retain) TimeStandardDataAccess * timeStandardDataAccess;

@end
