//
//  TimeStandardDataAccess.m
//  SQLitePractice
//
//  Created by JASON CROSS on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TimeStandardDataAccess.h"


@implementation TimeStandardDataAccess

- (NSString *) createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent: PNSTimesDataBaseFileName];
    success = [fileManager fileExistsAtPath: writableDBPath];
    if (!success) {
		// The writable database does not exist, so copy the default to the appropriate location.
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: PNSTimesDataBaseFileName];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if (!success) {
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
			return nil;
		}
	}
	return writableDBPath;
}

- (void) openDataBase {
	int result = sqlite3_open([[self createEditableCopyOfDatabaseIfNeeded] UTF8String], &database);
	
	if (result == SQLITE_OK) {
		databaseIsOpen = YES;
	}
	else {
		databaseIsOpen = NO;
		sqlite3_close(database);
		NSAssert(0, @"The database failed to open");
	}
}

- (NSArray *) prepareAndStepThroughStatementUsing: (NSString *) query  {
  sqlite3_stmt *statement;
	NSMutableArray * array = [NSMutableArray arrayWithCapacity:5];
	//NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:5];
	if (sqlite3_prepare_v2( database, [query UTF8String],
						   -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			char * valueStr		= (char*) sqlite3_column_text(statement, 1);
			NSString * valueObj = [[NSString alloc] initWithFormat: @"%s", valueStr];
			[array addObject:valueObj];
			[valueObj release];
		}
	}
	sqlite3_finalize(statement);
    return array;
}

- (NSArray *) getTimeStandardNames {
	if (databaseIsOpen == NO) {
		return nil;
	}
	NSString *query =  @"SELECT standardId, name from Standard";
	NSArray *array = [self prepareAndStepThroughStatementUsing: query];
	[query release];
	return array;
}

- (NSArray *) getAgeGroupNames: (NSString *) timeStandardName {
	if (databaseIsOpen == NO) {
		return nil;
	}
	NSString *query =  [[NSString alloc] initWithFormat: 
						@"SELECT AgeGroupID, AgeGroupName from vwTimeStandard\n"
						"where StandardName = '%@'\n"
						"GROUP BY AgeGroupName\n"
						"ORDER BY AgeGroupId;", timeStandardName];
	NSArray *array = [self prepareAndStepThroughStatementUsing: query];
	[query release];
	return array;
}

- (NSArray *) getAllStrokeNamesForStandardName: (NSString *) standardName 
									 andGender: (NSString *) gender
							   andAgeGroupName: (NSString *) ageGroupName {
	if (databaseIsOpen == NO) {
		return nil;
	}
	if (gender == nil) {
		gender = @"male";
	}
	NSString * convertedGender = ([[gender lowercaseString] isEqualToString: @"male"]) ? @"M" : @"F";
	NSString * query = [[NSString alloc] initWithFormat:
						@"SELECT DISTINCT EventId ,StrokeName\n"
						"FROM  vwTimeStandard\n"
						"WHERE StandardName = '%@'\n"
						"AND  Gender = '%@'\n"
						"AND  AgeGroupName = '%@'\n"
						"GROUP BY StrokeName\n"
						"ORDER BY EventId\n"
						";", standardName, convertedGender, ageGroupName];
	NSArray * array = [self prepareAndStepThroughStatementUsing:query];
	[query release];
	return array;	
}

- (NSArray *) getStrokeNamesForStandardName: (NSString *) standardName 
								  andGender: (NSString *) gender 
							andAgeGroupName: (NSString *) ageGroupName 
								andDistance: (NSString *) distance 
								  andFormat: (NSString *) format {
	if (databaseIsOpen == NO) {
		return nil;
	}
	if (gender == nil) {
		gender = @"male";
	}
	NSString * convertedGender = ([[gender lowercaseString] isEqualToString: @"male"]) ? @"M" : @"F";
	NSString * query = [[NSString alloc] initWithFormat:
						@"SELECT DISTINCT EventId ,StrokeName\n"
						"FROM  vwTimeStandard\n"
						"WHERE StandardName = '%@'\n"
						"AND  Gender = '%@'\n"
						"AND  AgeGroupName = '%@'\n"
						"AND  Distance = %@\n"
						"AND Format = '%@'\n"
						"GROUP BY StrokeName\n"
						"ORDER BY EventId\n"
						";", standardName, convertedGender, ageGroupName, distance, format];
	NSArray * array = [self prepareAndStepThroughStatementUsing:query];
	[query release];
	return array;
}

- (NSArray *) getDistancesForStandardName: (NSString *) standardName
								andGender: (NSString *) gender
						  andAgeGroupName: (NSString *) ageGroupName
							andStrokeName: (NSString *) strokeName
								andFormat: (NSString *) format {
	if (databaseIsOpen == NO) {
		return nil;
	}
	NSString * query;
	if (gender == nil) {
		gender = @"male";
	}
	NSString * convertedGender = ([[gender lowercaseString] isEqualToString: @"male"]) ? @"M" : @"F";
	if ((strokeName == nil) || (format == nil)) {
		query = [[NSString alloc] initWithFormat:
				 @"SELECT DISTINCT EventId, Distance\n"
				 @" FROM vwTimeStandard \n"
				 @"WHERE StandardName = '%@'\n"
				 @"  AND Gender = '%@'\n"
				 @"  AND AgeGroupName = '%@'\n"
				 @"GROUP BY Distance\n"
				 @"ORDER BY Distance\n"
				 ";", standardName, convertedGender, ageGroupName];
	}
	else {
		query = [[NSString alloc] initWithFormat:
				 @"SELECT DISTINCT EventId, Distance\n"
				 @" FROM vwTimeStandard \n"
				 @"WHERE StandardName = '%@'\n"
				 @"  AND Gender = '%@'\n"
				 @"  AND AgeGroupName = '%@'\n"
				 @"  AND StrokeName = '%@'\n"
				 @"  AND Format = '%@'\n"
				 @"GROUP BY Distance\n"
				 @"ORDER BY Distance\n"
				 ";", standardName, convertedGender, ageGroupName, strokeName, format];
	}
	NSArray * array = [self prepareAndStepThroughStatementUsing:query];
	[query release];
	return array;
}

- (NSArray *) getFormatForStandardName: (NSString *) standardName
							 andGender: (NSString *) gender
					   andAgeGroupName: (NSString *) ageGroupName
						   andDistance: (NSString *) distance
						 andStrokeName: (NSString *) strokeName {
	if (databaseIsOpen == NO) {
		return nil;
	}
	NSString * query;
	if (gender == nil) {
		gender = @"male";
	}
	NSString * convertedGender = ([[gender lowercaseString] isEqualToString: @"male"]) ? @"M" : @"F";
	if ((distance == nil) || (strokeName == nil)) {
		query = [[NSString alloc] initWithFormat:
				 @"SELECT DISTINCT EventId, Format\n"
				 @" FROM vwTimeStandard \n"
				 @"WHERE StandardName = '%@'\n"
				 @"  AND Gender = '%@'\n"
				 @"  AND AgeGroupName = '%@'\n"
				 @"GROUP BY Format\n"
				 @"ORDER BY Format\n"
				 ";", standardName, convertedGender, ageGroupName];
	}
	else {
		query = [[NSString alloc] initWithFormat:
				 @"SELECT DISTINCT EventId, Format\n"
				 @" FROM vwTimeStandard \n"
				 @"WHERE StandardName = '%@'\n"
				 @"  AND Gender = '%@'\n"
				 @"  AND AgeGroupName = '%@'\n"
				 @"  AND Distance = '%@'\n"
				 @"  AND StrokeName = '%@'\n"
				 @"GROUP BY Format\n"
				 @"ORDER BY Format\n"
				 ";", standardName, convertedGender, ageGroupName, distance, strokeName];
	}
	NSArray * array = [self prepareAndStepThroughStatementUsing:query];
	[query release];
	return array;
}

- (NSString *) getTimeForStandardName:(NSString *) standardName
							andGender: (NSString *) gender
					  andAgeGroupName: (NSString *) ageGroupName
						  andDistance: (NSString *) distance
						andStrokeName: (NSString *) strokeName
							andFormat: (NSString *) format {
	if (databaseIsOpen == NO) {
		return nil;
	}
	if (gender == nil) {
		gender = @"male";
	}
	NSString * convertedGender = ([[gender lowercaseString] isEqualToString: @"male"]) ? @"M" : @"F";
	NSString * query = [[NSString alloc] initWithFormat:
						@"SELECT DISTINCT EventId ,Time\n"
						"FROM  vwTimeStandard\n"
						"WHERE StandardName = '%@'\n"
						"AND  Gender = '%@'\n"
						"AND  AgeGroupName = '%@'\n"
						"AND  Distance = %@\n"
						@"AND StrokeName = '%@'\n"
						"AND  Format = '%@'\n"
						"GROUP BY StrokeName\n"
						"ORDER BY EventId\n"
						";", standardName, convertedGender, ageGroupName, distance, strokeName, format];
	NSArray * array = [self prepareAndStepThroughStatementUsing:query];
	[query release];
	NSString * timeString;
	if ((array != nil) && ([array count] > 0)) {
		timeString = [array objectAtIndex:0];
		[timeString retain];
	}
	return timeString;	
}

- (void) closeDataBase {
	sqlite3_close(database);
}

- (void) dealloc {
	[super dealloc];
}


@end
