//
//  PickerValues.m
//  pList Persistence
//
//  Created by JASON CROSS on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PickerValues.h"


@implementation PickerValues

@synthesize pickerDistance, pickerStrokeName, pickerCourse;

- (void) encodeWithCoder: (NSCoder *) encoder {
	[encoder encodeObject: pickerDistance
				   forKey: @"PickerDistance"];
	[encoder encodeObject: pickerStrokeName 
				   forKey: @"PickerStrokeName"];
	[encoder encodeObject: pickerCourse 
				   forKey: @"PickerCourse"];
}

- (id) initWithCoder: (NSCoder *) decoder {
	pickerDistance = [[decoder decodeObjectForKey:@"PickerDistance"] retain];
	pickerStrokeName = [[decoder decodeObjectForKey:@"PickerStrokeName"] retain];
	pickerCourse = [[decoder decodeObjectForKey:@"PickerCourse"] retain];
	return self;
}

@end
