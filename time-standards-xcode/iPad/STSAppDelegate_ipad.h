//
//  STSAppDelegate_ipad.h
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SwimmingTimeStandardsAppDelegate.h"

@interface STSAppDelegate_ipad : SwimmingTimeStandardsAppDelegate {
    UISplitViewController       * splitVC;
}

@property (nonatomic, retain) IBOutlet  UISplitViewController       * splitVC;

@end
