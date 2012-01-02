//
//  STSAppDelegate-iphone.m
//  SwimmingTimeStandards
//
//  Created by Jason Cross on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "STSAppDelegate_iphone.h"
#import "HomeScreenViewController_iphone.h"

@implementation STSAppDelegate_iphone

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Add the navigation controller's view to the window and display.
    // for some reason, setting the NavController in the NIB is not working, so do it programatically
    HomeScreenViewController_iphone * rootViewController = [[HomeScreenViewController_iphone alloc] init];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:rootViewController] autorelease];
    [rootViewController release];
    [self.window addSubview:self.navigationController.view];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
