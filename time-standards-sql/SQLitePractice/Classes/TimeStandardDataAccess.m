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
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent: kFileName];
    success = [fileManager fileExistsAtPath: writableDBPath];
    if (!success) {
		// The writable database does not exist, so copy the default to the appropriate location.
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: kFileName];
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

- (NSMutableArray *) prepareAndStepThroughStatementUsing: (NSString *) query  {
  sqlite3_stmt *statement;
	NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:5];
	
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
	NSMutableArray *array = [self prepareAndStepThroughStatementUsing: query];

	[query release];
	return [array autorelease];	
}

- (NSArray *) getAgeGroupNames: (int) timeStandardId {
	if (databaseIsOpen == NO) {
		return nil;
	}
	NSString *query =  [[NSString alloc] initWithFormat: 
						@"SELECT AG.AgeGroupId, AG.Name from TimeStandard as TS\n"
						"JOIN AgeGROUP AS AG ON TS.AgeGroupId = AG.AgeGroupId\n" 
						"where TS.StandardID = %i\n"
						"GROUP BY AG.Name\n"
						"ORDER BY AG.AgeGroupId ASC;", timeStandardId];
	NSMutableArray *array = [self prepareAndStepThroughStatementUsing: query];
	[query release];
	return [array autorelease];	
}

- (void) closeDataBase {
	sqlite3_close(database);
}


@end
