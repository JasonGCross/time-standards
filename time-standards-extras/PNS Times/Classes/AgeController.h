//
//  AgeCategoryController.h
//  PNS Times
//
//  Created by JASON CROSS on 7/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopLevelSettingViewController.h"

@class TimeStandardDataAccess;

@interface AgeController : TopLevelSettingViewController {
	NSUInteger	age;
	NSString	* timeStandardName;
}

@property (nonatomic, retain) NSString	* timeStandardName;

+ (AgeController *) ageControllerWithDefaults;

@end
