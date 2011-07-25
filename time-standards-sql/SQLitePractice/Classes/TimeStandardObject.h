//
//  TimeStandardObject.h
//  SQLitePractice
//
//  Created by JASON CROSS on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSString.h>

// gender
typedef enum {
	male,
	female
} PNSTimesGender;

// strokeName
typedef enum {
	freestyle,
	backstroke,
	breaststroke,
	butterfly,
	individualMedley,
	medleyRelay,
	freeRelay
} PNSTimesStrokeName;

// course
typedef enum {
	SCM,
	SCY,
	LCM
} PNSTimesCourse;

#define kFileName @"SwimTimes"

@interface TimeStandardObject : NSObject {
	NSInteger			eventId;
	NSInteger			distance;
	PNSTimesStrokeName	strokeName;
	NSInteger			standardId;
	PNSTimesGender		gender;
	NSString *			standardName;
	NSDate *			standardDate;
	NSInteger			ageGroupId;
	NSString *			ageGroupName;
	PNSTimesCourse		course;
}

@property NSInteger				eventId;
@property NSInteger				distance;
@property PNSTimesStrokeName	strokeName;
@property NSInteger				standardId;
@property PNSTimesGender		gender;
@property (nonatomic, retain)	NSString *		standardName;
@property (nonatomic, retain)	NSDate *		standardDate;
@property NSInteger				ageGroupId;
@property (nonatomic, retain)	NSString *		ageGroupName;
@property PNSTimesCourse		course;

@end
