/*
 *  PNS_TimesGlobals.h
 *  PNS Times
 *
 *  Created by JASON CROSS on 7/20/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

// custom cel value tags
#define PNSTimesSettingKeyLabelTag			1
#define PNSTimesSettingValueLabelTag		2
#define PNSTimesDataBaseFileName			@"SwimTimes"
#define PNSDistanceComponent				1
#define PNSStrokeComponent					0
#define PNSCourseComponent					2

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




