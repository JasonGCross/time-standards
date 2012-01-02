/*
 *  SwimmingTimesStandards_TimesGlobals.h
 *  SwimmingTimesStandards Times
 *
 *  Created by JASON CROSS on 7/20/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

// custom cel value tags
#define	STSStandardRow					0
#define STSSwimmerRow					1
#define STSDataBaseFileName				@"SwimTimes_v2.sqlite"
#define STSPersistentStoreFileName      @"HomeScreenValues.sqlite"
#define STSHomeScreenArchiveFileName	@"homeScreenValues.arch"
#define STSImageThumnailName			@"headshot.png"
#define STSHomeScreenValuesChangedKey   @"STSHomeScreenValuesChangedNotificationKey"
#define STSDistanceComponent			1
#define STSStrokeComponent				0
#define STSCourseComponent				2
#define STSCustomButtonHeight			30.0

// gender
typedef enum {
	male,
	female
} STSGender;

// strokeName
typedef enum {
	freestyle,
	backstroke,
	breaststroke,
	butterfly,
	individualMedley,
	medleyRelay,
	freeRelay
} STSStrokeName;

// course
typedef enum {
	SCM,
	SCY,
	LCM
} STSCourse;

// timeStandards and Swimmers (iPad)
typedef enum timeStandardSwimmerSections {
    timeStandardSection,
    swimmerSection,
    sectionCount
} TimeStandardSwimmerSections;




