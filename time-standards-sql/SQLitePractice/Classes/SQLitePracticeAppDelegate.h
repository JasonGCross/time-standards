//
//  SQLitePracticeAppDelegate.h
//  SQLitePractice
//
//  Created by JASON CROSS on 7/28/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "/usr/include/sqlite3.h"
#import "TimeStandardDataAccess.h"

@interface SQLitePracticeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow	*window;
	TimeStandardDataAccess * tsDataAccess;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

