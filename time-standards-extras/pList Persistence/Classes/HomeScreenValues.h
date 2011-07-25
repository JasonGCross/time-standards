//
//  HomeScreenValues.h
//  pList Persistence
//
//  Created by JASON CROSS on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Swimmer;
@class PickerValues;

@interface HomeScreenValues : NSObject <NSCoding> {
	Swimmer			* swimmer;
	NSString		* standard;
	PickerValues	* pickerValues;
}

@property (nonatomic, retain) Swimmer		* swimmer;
@property (nonatomic, retain) NSString		* standard;
@property (nonatomic, retain) PickerValues	* pickerValues;

@end
