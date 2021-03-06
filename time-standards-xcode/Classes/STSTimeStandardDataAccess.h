//
//  TimeStandardDataAccess.h
//  SQLitePractice
//
//  Created by JASON CROSS on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface STSTimeStandardDataAccess : NSObject {
	sqlite3		*database;
	BOOL		databaseIsOpen;
}

+ (STSTimeStandardDataAccess *) sharedDataAccess;

- (NSString *) createEditableCopyOfDatabaseIfNeeded;
- (void) openDataBase;
- (void) closeDataBase;

- (NSArray *) getAllTimeStandardNames;
- (NSArray *) getAllAgeGroupNames: (NSString *) timeStandardName;
- (BOOL) timeStandard: (NSString *) timeStandardName 
  doesContainAgeGroup: (NSString *) ageGroupName;
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
								andFormat: (NSString *) format 
                    putKeysIntoDictionary: (NSDictionary **) dict;
- (NSArray *) getFormatForStandardName: (NSString *) standardName
							 andGender: (NSString *) gender
					   andAgeGroupName: (NSString *) ageGroupName
						   andDistance: (NSString *) distance
						 andStrokeName: (NSString *) strokeName;
- (NSString *) getTimeForKeyId:(NSString *) keyId;


@end
