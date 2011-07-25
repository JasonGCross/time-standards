//
//  Swimmer.m
//  pList Persistence
//
//  Created by JASON CROSS on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Swimmer.h"


@implementation Swimmer

@synthesize swimmerName, swimmerGender, swimmerAgeGroup;

- (void) encodeWithCoder: (NSCoder *) encoder {
	[encoder encodeObject: swimmerName
				   forKey: @"SwimmerName"];
	[encoder encodeObject: swimmerGender 
				   forKey: @"SwimmerGender"];
	[encoder encodeObject: swimmerAgeGroup 
				   forKey:@"SwimmerAgeGroup"];
}

- (id) initWithCoder: (NSCoder *) decoder {
	swimmerName = [[decoder decodeObjectForKey:@"SwimmerName"] retain];
	swimmerGender = [[decoder decodeObjectForKey:@"SwimmerGender"] retain];
	swimmerAgeGroup = [[decoder decodeObjectForKey:@"SwimmerAgeGroup"] retain];
	return self;
}


@end
