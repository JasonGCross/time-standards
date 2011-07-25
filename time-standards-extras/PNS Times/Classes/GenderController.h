//
//  GenderController.h
//  PNS Times
//
//  Created by JASON CROSS on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopLevelSettingViewController.h"

@interface GenderController : TopLevelSettingViewController {
	PNSTimesGender gender;
}

+ (GenderController *) genderControllerWithDefaults;

@end
