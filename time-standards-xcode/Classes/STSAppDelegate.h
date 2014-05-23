//
//  SwimmingTimeStandardsAppDelegate.h
//  SwimmingTimeStandards
//
//  Created by JASON CROSS on 8/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface STSAppDelegate : NSObject <UIApplicationDelegate>

// don't delete; the app actually needs these properties to run
@property (nonatomic, strong) IBOutlet	UIWindow					* window;
@property (nonatomic, strong) IBOutlet	UINavigationController		* navigationController;

@end

