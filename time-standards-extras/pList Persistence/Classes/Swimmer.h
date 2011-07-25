//
//  Swimmer.h
//  pList Persistence
//
//  Created by JASON CROSS on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Swimmer : NSObject <NSCoding> {
	NSString * swimmerName;
	NSString * swimmerGender;
	NSString * swimmerAgeGroup;
}

@property (nonatomic, retain) NSString * swimmerName;
@property (nonatomic, retain) NSString * swimmerGender;
@property (nonatomic, retain) NSString * swimmerAgeGroup;

@end
