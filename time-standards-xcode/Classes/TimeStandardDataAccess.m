//
//  TimeStandardDataAccess.m
//  SwimmingTimesStandards
//
//  Created by JASON CROSS on 7/31/10.
//  Copyright 2010 Cross Swim Training. All rights reserved.
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
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent: STSDataBaseFileName];
    success = [fileManager fileExistsAtPath: writableDBPath];
//	if(success) {
//		// normally, comment out this section unless you want to explicity over-write the file
//		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: STSDataBaseFileName];
//		BOOL hasBeenOverWritten = [fileManager removeItemAtPath:writableDBPath error:&error];
//		if (!hasBeenOverWritten) {
//			NSAssert1(0, @"Failed to overwrite database file with message: '%@'.", [error localizedDescription]);
//			return nil;
//		}
//		hasBeenOverWritten = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
//		if (!hasBeenOverWritten) {
//			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
//			return nil;
//		}
//	}
    if (!success) {
		// The writable database does not exist, so copy the default to the appropriate location.
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: STSDataBaseFileName];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if (!success) {
			NSLog(@"Failed to create writable database file");
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Failure creating database"
								  message:@"Could not create the database"
								  delegate:nil
								  cancelButtonTitle:@"Acknowledge"
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
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
		NSLog(@"Failed to open database.");
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Failure opening database"
							  message:@"Could not open the database"
							  delegate:nil
							  cancelButtonTitle:@"Acknowledge"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (NSArray *) getAllTimeStandardNames {
	if (databaseIsOpen == NO) {
		return nil;
	}
	static char *query =  "SELECT DISTINCT standardId, StandardFriendly from ReportTimeStandard";
	
	sqlite3_stmt *statement;
	NSMutableArray * array = [NSMutableArray arrayWithCapacity:5];
	int returnCode = sqlite3_prepare_v2(database, query, -1, &statement, nil);
	if (returnCode == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			char * valueStr		= (char*) sqlite3_column_text(statement, 1);
			NSString * valueObj = [[NSString alloc] initWithUTF8String: valueStr];
			[array addObject:valueObj];
			[valueObj release];
		}
	}
	sqlite3_finalize(statement);
	
	return array;
}

- (NSArray *) getAllAgeGroupNames: (NSString *) timeStandardName {
	if (databaseIsOpen == NO) {
		return nil;
	}
	static char *query =  
        "SELECT AgeGroupID, AgeGroupName\n\
            FROM  ReportTimeStandard\n\
            WHERE StandardFriendly = ?\n\
        GROUP BY AgeGroupName\n\
        ORDER BY AgeGroupId;";
	
	sqlite3_stmt *statement;
	NSMutableArray * array = [NSMutableArray arrayWithCapacity:5];
	int returnCode = sqlite3_prepare_v2(database, query, -1, &statement, nil);
	if (returnCode == SQLITE_OK) {
		sqlite3_bind_text(statement, 1, [timeStandardName UTF8String], -1, SQLITE_STATIC);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			char * valueStr		= (char*) sqlite3_column_text(statement, 1);
			NSString * valueObj = [[NSString alloc] initWithUTF8String: valueStr];
			[array addObject:valueObj];
			[valueObj release];
		}
	}
	sqlite3_finalize(statement);
	
	return array;
}

- (BOOL) timeStandard: (NSString *) timeStandardName 
  doesContainAgeGroup: (NSString *) ageGroupName {
	if (databaseIsOpen == NO) {
		return NO;
	}
	static char *query =  
        "SELECT AgeGroupID, AgeGroupName\n\
            FROM  ReportTimeStandard\n\
            WHERE StandardFriendly = ?\n\
                AND AgeGroupName = ?\n\
        ORDER BY AgeGroupId;";
	
	sqlite3_stmt *statement;
	NSMutableArray * array = [NSMutableArray arrayWithCapacity:5];
	int returnCode = sqlite3_prepare_v2(database, query, -1, &statement, nil);
	if (returnCode == SQLITE_OK) {
		sqlite3_bind_text(statement, 1, [timeStandardName UTF8String], -1, SQLITE_STATIC);
		sqlite3_bind_text(statement, 2, [ageGroupName UTF8String], -1, SQLITE_STATIC);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			char * valueStr		= (char*) sqlite3_column_text(statement, 1);
			NSString * valueObj = [[NSString alloc] initWithUTF8String: valueStr];
			[array addObject:valueObj];
			[valueObj release];
		}
	}
	sqlite3_finalize(statement);
	
	if ((array != nil) && ([array count] > 0)) {
		return YES;
	}
	return NO;
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
	static char * query = 
        "SELECT DISTINCT StrokeId ,StrokeName\n\
            FROM  ReportTimeStandard\n\
            WHERE StandardFriendly = ?\n\
                AND  Gender = ?\n\
                AND  AgeGroupName = ?\n\
        ORDER BY EventId;";
	
	sqlite3_stmt *statement;
	NSMutableArray * array = [NSMutableArray arrayWithCapacity:5];
	int returnCode = sqlite3_prepare_v2(database, query, -1, &statement, nil);
	if (returnCode == SQLITE_OK) {
		sqlite3_bind_text(statement, 1, [standardName UTF8String], -1, SQLITE_STATIC);
		sqlite3_bind_text(statement, 2, [convertedGender UTF8String], -1, SQLITE_STATIC);
		sqlite3_bind_text(statement, 3, [ageGroupName UTF8String], -1, SQLITE_STATIC);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			char * valueStr		= (char*) sqlite3_column_text(statement, 1);
			NSString * valueObj = [[NSString alloc] initWithUTF8String: valueStr];
			[array addObject:valueObj];
			[valueObj release];
		}
	}
	sqlite3_finalize(statement);
	
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
	static char * query = 
        "SELECT EventId ,StrokeName\n\
            FROM  ReportTimeStandard\n\
            WHERE StandardFriendly = ?\n\
                AND  Gender = ?\n\
                AND  AgeGroupName = ?\n\
                AND  Distance = ?\n\
                AND Format = ?\n\
        ORDER BY EventId;";
	
	sqlite3_stmt *statement;
	NSMutableArray * array = [NSMutableArray arrayWithCapacity:5];
	int returnCode = sqlite3_prepare_v2(database, query, -1, &statement, nil);
	if (returnCode == SQLITE_OK) {
		sqlite3_bind_text(statement, 1, [standardName UTF8String], -1, SQLITE_STATIC);
		sqlite3_bind_text(statement, 2, [convertedGender UTF8String], -1, SQLITE_STATIC);
		sqlite3_bind_text(statement, 3, [ageGroupName UTF8String], -1, SQLITE_STATIC);
		sqlite3_bind_int(statement, 4, [distance intValue]);
		sqlite3_bind_text(statement, 5, [format UTF8String], -1, SQLITE_STATIC);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			char * valueStr		= (char*) sqlite3_column_text(statement, 1);
			NSString * valueObj = [[NSString alloc] initWithUTF8String: valueStr];
			[array addObject:valueObj];
			[valueObj release];
		}
	}
	sqlite3_finalize(statement);
	
	return array;
}

- (NSArray *) getDistancesForStandardName: (NSString *) standardName
								andGender: (NSString *) gender
						  andAgeGroupName: (NSString *) ageGroupName
							andStrokeName: (NSString *) strokeName
								andFormat: (NSString *) format                       
                    putKeysIntoDictionary: (NSDictionary **) outDictionary  {
	if (databaseIsOpen == NO) {
		return nil;
	}

	if (gender == nil) {
		gender = @"male";
	}
	NSString * convertedGender = ([[gender lowercaseString] isEqualToString: @"male"]) ? @"M" : @"F";
	
	static char * query1 = "SELECT DISTINCT EventId, Distance, KeyId\n\
	FROM  ReportTimeStandard\n\
    WHERE StandardFriendly = ?\n\
        AND Gender = ?\n\
        AND AgeGroupName = ?\n\
        AND StrokeName = ?4\n\
	ORDER BY Distance;";
	
	static char * query2 = "SELECT DISTINCT EventId, Distance, KeyId\n\
	FROM  ReportTimeStandard\n\
    WHERE StandardFriendly = ?\n\
        AND Gender = ?\n\
        AND AgeGroupName = ?\n\
        AND Format = ?5\n\
	ORDER BY Distance;";
	
	static char * query3 = "SELECT DISTINCT EventId, Distance, KeyId\n\
	FROM  ReportTimeStandard\n\
        WHERE StandardFriendly = ?\n\
        AND Gender = ?\n\
        AND AgeGroupName = ?\n\
	ORDER BY Distance;";
	
	static char * query4 = "SELECT DISTINCT EventId, Distance, KeyId\n\
	FROM  ReportTimeStandard\n\
        WHERE StandardFriendly = ?\n\
        AND Gender = ?\n\
        AND AgeGroupName = ?\n\
        AND StrokeName = ?4\n\
        AND Format = ?5\n\
	ORDER BY Distance;";

	sqlite3_stmt *statement;
	NSMutableArray * array = [NSMutableArray arrayWithCapacity:6];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithCapacity:6];
	
	
	// must take into account that strokeName may be nil, or format may be nil, or both
	if ((strokeName != nil) && (format == nil)) {
		int returnCode = sqlite3_prepare_v2(database, query1, -1, &statement, nil);
		if (returnCode == SQLITE_OK) {
			sqlite3_bind_text(statement, 1, [standardName UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 2, [convertedGender UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 3, [ageGroupName UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 4, [strokeName UTF8String], -1, SQLITE_STATIC);
			
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char * valueStr		= (char*) sqlite3_column_text(statement, 1);
				NSString * valueObj = [[NSString alloc] initWithUTF8String: valueStr];
				[array addObject:valueObj];
                
                char * keyStr = (char*) sqlite3_column_text(statement, 2);
                NSString * keyObj = [[NSString alloc] initWithUTF8String:keyStr];
                [dictionary setObject:keyObj forKey:valueObj];
                [valueObj release];
                [keyObj release];
			}
		}
	}
	else if ((strokeName == nil) && (format != nil)) {
		int returnCode = sqlite3_prepare_v2(database, query2, -1, &statement, nil);
		if (returnCode == SQLITE_OK) {
			sqlite3_bind_text(statement, 1, [standardName UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 2, [convertedGender UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 3, [ageGroupName UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 5, [format UTF8String], -1, SQLITE_STATIC);
			
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char * valueStr		= (char*) sqlite3_column_text(statement, 1);
				NSString * valueObj = [[NSString alloc] initWithUTF8String: valueStr];
				[array addObject:valueObj];
                
                char * keyStr = (char*) sqlite3_column_text(statement, 2);
                NSString * keyObj = [[NSString alloc] initWithUTF8String:keyStr];
                [dictionary setObject:keyObj forKey:valueObj];
                [valueObj release];
                [keyObj release];
			}
		}
		
	}
	else if ((strokeName == nil) && (format == nil)) {
		int returnCode = sqlite3_prepare_v2(database, query3, -1, &statement, nil);
		if (returnCode == SQLITE_OK) {
			sqlite3_bind_text(statement, 1, [standardName UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 2, [convertedGender UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 3, [ageGroupName UTF8String], -1, SQLITE_STATIC);
			
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char * valueStr		= (char*) sqlite3_column_text(statement, 1);
				NSString * valueObj = [[NSString alloc] initWithUTF8String: valueStr];
				[array addObject:valueObj];
                
                char * keyStr = (char*) sqlite3_column_text(statement, 2);
                NSString * keyObj = [[NSString alloc] initWithUTF8String:keyStr];
                [dictionary setObject:keyObj forKey:valueObj];
                [valueObj release];
                [keyObj release];
			}
		}
	}
	else {
		int returnCode = sqlite3_prepare_v2(database, query4, -1, &statement, nil);
		if (returnCode == SQLITE_OK) {
			sqlite3_bind_text(statement, 1, [standardName UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 2, [convertedGender UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 3, [ageGroupName UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 4, [strokeName UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 5, [format UTF8String], -1, SQLITE_STATIC);
			
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char * valueStr		= (char*) sqlite3_column_text(statement, 1);
				NSString * valueObj = [[NSString alloc] initWithUTF8String: valueStr];
				[array addObject:valueObj];
                
                char * keyStr = (char*) sqlite3_column_text(statement, 2);
                NSString * keyObj = [[NSString alloc] initWithUTF8String:keyStr];
                [dictionary setObject:keyObj forKey:valueObj];
                [valueObj release];
                [keyObj release];
			}
		}
	}
	
	sqlite3_finalize(statement);
	
    *outDictionary = [NSDictionary dictionaryWithDictionary:dictionary];
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
	
	if (gender == nil) {
		gender = @"male";
	}
	NSString * convertedGender = ([[gender lowercaseString] isEqualToString: @"male"]) ? @"M" : @"F";
	
	static char * query1 = "SELECT DISTINCT EventId, Format\n\
	FROM  ReportTimeStandard\n\
    WHERE StandardFriendly = ?\n\
        AND Gender = ?\n\
        AND AgeGroupName = ?\n\
    GROUP BY Format\n\
	ORDER BY Format DESC;";
	
	static char * query2 = "SELECT DISTINCT EventId, Format\n\
	FROM  ReportTimeStandard\n\
    WHERE StandardFriendly = ?\n\
        AND Gender = ?\n\
        AND AgeGroupName = ?\n\
        AND Distance = ?\n\
        AND StrokeName = ?\n\
    GROUP BY Format\n\
	ORDER BY Format DESC;";
	
	sqlite3_stmt *statement;
	NSMutableArray * array = [NSMutableArray arrayWithCapacity:5];
	
	
	// if either distance or stroke are null, ingore both (as in the case when the 
	// picker is first loading)
	if ((distance == nil) || (strokeName == nil)) {
		int returnCode = sqlite3_prepare_v2(database, query1, -1, &statement, nil);
		if (returnCode == SQLITE_OK) {
			sqlite3_bind_text(statement, 1, [standardName UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 2, [convertedGender UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 3, [ageGroupName UTF8String], -1, SQLITE_STATIC);
			
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char * valueStr		= (char*) sqlite3_column_text(statement, 1);
				NSString * valueObj = [[NSString alloc] initWithUTF8String: valueStr];
				[array addObject:valueObj];
				[valueObj release];
			}
		}
		
	}
	else {
		int returnCode = sqlite3_prepare_v2(database, query2, -1, &statement, nil);
		if (returnCode == SQLITE_OK) {
			sqlite3_bind_text(statement, 1, [standardName UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 2, [convertedGender UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_text(statement, 3, [ageGroupName UTF8String], -1, SQLITE_STATIC);
			sqlite3_bind_int(statement, 4, [distance intValue]);
			sqlite3_bind_text(statement, 5, [strokeName UTF8String], -1, SQLITE_STATIC);
			
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char * valueStr		= (char*) sqlite3_column_text(statement, 1);
				NSString * valueObj = [[NSString alloc] initWithUTF8String: valueStr];
				[array addObject:valueObj];
				[valueObj release];
			}
		}
	}
	
	sqlite3_finalize(statement);
	
	return array;
}

- (NSString *) getTimeForKeyId:(NSString *) keyId {
	if (databaseIsOpen == NO) {
		return nil;
	}
    
    static char * query = 
    "SELECT EventId ,Time\n\
    FROM  ReportTimeStandard\n\
    WHERE keyId = ?\n\
    ORDER BY EventId;";
    
	sqlite3_stmt *statement;
	NSMutableArray * array = [NSMutableArray arrayWithCapacity:5];
	int returnCode = sqlite3_prepare_v2(database, query, -1, &statement, nil);
	if (returnCode == SQLITE_OK) {
		sqlite3_bind_int(statement, 1, [keyId intValue]);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			char * valueStr		= (char*) sqlite3_column_text(statement, 1);
			NSString * valueObj = [[NSString alloc] initWithUTF8String: valueStr];
			[array addObject:valueObj];
			[valueObj release];
		}
	}
	sqlite3_finalize(statement);
	
	NSString * timeString = nil;
	if ((array != nil) && ([array count] > 0)) {
		timeString = [array objectAtIndex:0];
		[[timeString retain] autorelease];
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
