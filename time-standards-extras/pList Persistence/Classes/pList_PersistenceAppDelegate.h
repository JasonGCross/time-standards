//
//  pList_PersistenceAppDelegate.h
//  pList Persistence
//
//  Created by JASON CROSS on 9/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFileName @"homeScreenValues.arch"

@class HomeScreenValues;

@interface pList_PersistenceAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	HomeScreenValues * homeScreenValues;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

-(NSString *) dataFilePath;

@end

