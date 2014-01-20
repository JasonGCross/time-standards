//
//  STSAppDelegate_ipad.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "STSAppDelegate_ipad.h"

@implementation STSAppDelegate_ipad 


@synthesize splitVC;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    [self.window addSubview:self.splitVC.view];

    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


@end
