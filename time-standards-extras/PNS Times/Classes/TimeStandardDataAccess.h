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
- (NSArray *) getAgeGroupNames: (NSString *) timeStandardName;
- (NSArray *) getAllStrokeNamesForStandardName: (NSString *) standardName 
								  andGender: (NSString *) gender 
							andAgeGroupName: (NSString *) ageGroupName;
- (NSArray *) getStrokeNamesForStandardName: (NSString *) standardName 
								  andGender: (NSString *) gender 
							andAgeGroupName: (NSString *) ageGroupName 
								andDistance: (NSString *) distance 
								  andFormat: (NSString *) format;
- (NSArray *) getDistancesForStandardName: (NSString *) standardName
								andGender: (NSString *) gender
						  andAgeGroupName: (NSString *) ageGroupName
							andStrokeName: (NSString *) strokeName
								andFormat: (NSString *) format;
- (NSArray *) getFormatForStandardName: (NSString *) standardName
							 andGender: (NSString *) gender
					   andAgeGroupName: (NSString *) ageGroupName
						   andDistance: (NSString *) distance
						 andStrokeName: (NSString *) strokeName;
- (NSString *) getTimeForStandardName:(NSString *) standardName
							andGender: (NSString *) gender
					  andAgeGroupName: (NSString *) ageGroupName
						  andDistance: (NSString *) distance
						andStrokeName: (NSString *) strokeName
							andFormat: (NSString *) format;


@end
