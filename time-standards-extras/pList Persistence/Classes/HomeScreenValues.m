//
//  HomeScreenValues.m
//  pList Persistence
//
//  Created by JASON CROSS on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HomeScreenValues.h"


@implementation HomeScreenValues

@synthesize swimmer, standard, pickerValues;

- (void) encodeWithCoder: (NSCoder *) encoder {
	[encoder encodeObject: swimmer
				   forKey: @"HomeScreenSwimmer"];
	[encoder encodeObject: standard 
				   forKey: @"HomeScreenStandard"];
	[encoder encodeObject: pickerValues 
				   forKey: @"HomeScreenPickerValues"];
}

- (id) initWithCoder: (NSCoder *) decoder {
	swimmer = [[decoder decodeObjectForKey:@"HomeScreenSwimmer"] retain];
	standard = [[decoder decodeObjectForKey:@"HomeScreenStandard"] retain];
	pickerValues = [[decoder decodeObjectForKey:@"HomeScreenPickerValues"] retain];
	return self;
}


@end
