//
//  TimeStandardDataAccess.h
//  SQLitePractice
//
//  Created by JASON CROSS on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"
#import "TimeStandardObject.h"

@interface TimeStandardDataAccess : NSObject {
	sqlite3		*database;
	BOOL		databaseIsOpen;
}

- (NSString *) createEditableCopyOfDatabaseIfNeeded;
- (void) openDataBase;
- (void) closeDataBase;

- (NSArray *) getTimeStandardNames;
- (NSArray *) getAgeGroupNames: (int) timeStandardId;

@end
