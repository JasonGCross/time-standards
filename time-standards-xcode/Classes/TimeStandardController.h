//
//  TimeStandardController.h
//  PNS Times
//
//  Created by JASON CROSS on 7/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwimmingTimeStandardsAppDelegate;

@interface TimeStandardController : UITableViewController {
	NSString 		* settingLabelText;
	NSString		* settingValue;
	NSArray 	    * _settingList;
	NSIndexPath		* _lastIndexPath;
	SwimmingTimeStandardsAppDelegate * _appDelegate;
}

@property (nonatomic, retain) NSString * settingLabelText;
@property (nonatomic, retain) NSString * settingValue;

@end
