/*
 *  SwimmingTimesStandards_TimesGlobals.h
 *  SwimmingTimesStandards Times
 *
 *  Created by JASON CROSS on 7/20/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

// custom cel value tags



#define STSDataBaseFileName				@"SwimTimes_v4.sqlite"
#define STSPersistentStoreFileName      @"HomeScreenValues.sqlite"
#define STSHomeScreenArchiveFileName	@"homeScreenValues.arch"
#define STSImageThumnailName			@"headshot.png"
#define STSCustomButtonHeight			30.0
#define STSHomeScreenValuesChangedKey   @"STSHomeScreenValuesChangedNotificationKey"
#define STSSwimmerPhotoChangedKey       @"STSSwimmerPhotoChangedNotificationKey"
#define STSSwimmerNameChangedKey        @"STSSwimmerNameChangedNotificationKey"


// gender
typedef NS_ENUM(NSUInteger, STSGender) {
	male,
	female
} ;

// strokeName
typedef NS_ENUM(NSUInteger, STSStrokeName) {
	freestyle,
	backstroke,
	breaststroke,
	butterfly,
	individualMedley,
	medleyRelay,
	freeRelay
};

// course
typedef NS_ENUM(NSUInteger, STSCourse) {
	SCM,
	SCY,
	LCM
};

// timeStandards and Swimmers (iPad)
typedef NS_ENUM(NSUInteger, TimeStandardSwimmerSections) {
    timeStandardSection,
    swimmerSection,
    sectionCount
};




